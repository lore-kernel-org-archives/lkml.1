Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbZAFWtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbZAFWtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbZAFWtC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:49:02 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:28497 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753839AbZAFWs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:48:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fhlwBihGxEQSFOSHdfqyNEND6wCR9fMY36K1YVKOg1nqUrRagSNY7ExuN7ypQh2R66tQThp5BNU6FgdE4hF/nsG4gsxnKuJm9E+bYuC0mGfl+rnhLuAZ+FY5+RTEakWCvnmf38pUjWey8kH7GsTvYu3ZyQzOk9Ih8mCYFLnErZs=  ;
X-YMail-OSG: uDevnLUVM1nXJ6eeMjttfBnS8uio0sqx21skCcw606rWQSPdyBMCTlsLt7Kh8H7qE4Ccb_.NhatwGU45J7ClncFjF.3BHGcoqesDyevbHhZo2BsLcuhx.zjIH0EhBtvPzAr60mmKHKEzuH7pZnjCWqhe
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ed Swierk <eswierk@aristanetworks.com>
Subject: Re: [PATCH] rtc-ds1307: True SMBus compatibility
Date: Tue, 6 Jan 2009 14:48:55 -0800
User-Agent: KMail/1.9.10
Cc: linux-i2c@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       BARRE Sebastien <sbarre@sdelcc.com>
References: <1231177261.13443.20.camel@localhost.localdomain>
In-Reply-To: <1231177261.13443.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901061448.56500.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2009, Ed Swierk wrote:
> Reading or writing registers repeatedly until they stick is rather
> nauseating but I'm aiming for correctness if not elegance.  I would
> appreciate any suggestions for improvement.

Can i2c_smbus_read_i2c_block_data()/i2c_ smbus_write_i2c_block_data()
work better -- without nauseating anyone?

Faking atomic writes doesn't seem "correct" to me.  Minimally there
is the case of an alarm misfiring.

- Dave
