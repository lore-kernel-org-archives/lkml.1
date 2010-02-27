Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab0B0HEv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 02:04:51 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:45989 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753878Ab0B0HEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 02:04:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IbmGo7rkQpm85ikxBgQmtFSojAXxq5wHVNR1VeADzwFUaCxvtDk6hqRKF0a64hKg63kTG7W/1lkbVA0q1g/Lahtfr2CRDsyM5rPW4meakwFiUSVuqAU3BfpLvNCcY3g4GkZJT9i5N1zfWX98QGsgCsIE+Cff0FSYqykBdpFwXSU=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: nT1qVjUVM1mRUzVnXhV2WmppheaMJpuhW8ZdJJLRuoMSkuvgMlreiHquU9UzftPxjWcAMAIoz6BVIo6MOGbWy_TivWOsno4gaXwGS0jkmkGmfKkF205dBtg0wd0sBMIY13cPXIRMtZ9F6WxMmU8e5PbgEgfzhbiwuCgTmDEtxy26Bz1f9mHjdfQrzhD5e1TV9u6oSzm_TtzK2oXiOA6qQIOmXaTl1BfMnrPVNNtzyOjaY8XUrwp49.UNzdHJOJMMzrcmc7W0vNI1KA3XsVg-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Gardner <gardner.ben@gmail.com>
Subject: Re: [PATCH 2/3] cs5535-gpio: Use set_direction
Date: Fri, 26 Feb 2010 23:04:49 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
References: <cover.1267225701.git.gardner.ben@gmail.com> <6787cce8528c344c496724509762b2a11dea4bfb.1267225701.git.gardner.ben@gmail.com>
In-Reply-To: <6787cce8528c344c496724509762b2a11dea4bfb.1267225701.git.gardner.ben@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002262304.49768.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 February 2010, Ben Gardner wrote:
> The CS5535 GPIO has independant controls for input and output enable.

Unusual, but not causing any conceptual problem.


> Use the set_direction method instead of direction_input and direction_output
> to enable use of the bidirectional mode.

Any reason you aren't making the standard behavior be:

	input ... input enabled
	output ... both enabled

That would make this driver behave like most other GPIO hardware, which
would help you avoid subtle problems.

Would there be any technical downside to that approach?


