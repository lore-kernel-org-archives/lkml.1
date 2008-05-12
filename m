Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbYELQyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbYELQyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 12:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbYELQyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 12:54:10 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:23845 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751588AbYELQyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 12:54:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=US2O2HIDO4v5+VjHlUCM86UDW/kcPzsvD1WIoxTeUFBDkKdCfbkrmkhYfWtCadx7M2h6RlE06CR7YGhOteKCCnHOkV5wDS9ndG5SYa3Gh0Gh5bTfNMF7OwsBfrybvkAdV2bULQlIw0mK52Y6oeEy1qhJlvBdmnMqhGr5kaH/7vw=  ;
X-YMail-OSG: SW8phHsVM1mXL2o_Rvp5OZXF5rvoOsalqs1CazGHNkVF55IHtlVFDxB6J.Sq3iW_jLoOu6FrHqjEnn04hTTBuwlThUibG1ietYUHWMSJvwRf804FwJKofaW3Q06TzmF24eA-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Bryan Wu" <cooloney@kernel.org>
Subject: Re: [PATCH 1/1] [INPUT/KEYPAD] gpio keypad: Replace current blackfin specific pfbutton driver with kernel generic gpio key driver
Date: Mon, 12 May 2008 09:54:06 -0700
User-Agent: KMail/1.9.6
Cc: "Mike Frysinger" <vapier.adi@gmail.com>,
       "pHilipp Zabel" <philipp.zabel@gmail.com>,
       dbrownell@users.sourceforge.net, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
References: <1210587437-9751-1-git-send-email-cooloney@kernel.org> <8bd0f97a0805120547g5c46973fl538ad18d81a4aebc@mail.gmail.com> <386072610805120742k47e2433cxf7a1f8605fca47fb@mail.gmail.com>
In-Reply-To: <386072610805120742k47e2433cxf7a1f8605fca47fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805120954.06986.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 May 2008, Bryan Wu wrote:
> Right. I mean the generic GPIO layer in Blackfin port, not the common code.
> 
> And on the other hand, maybe there are also other hardware which has similar
> issue as Blackfin. So the common GPIO layer can take care of this, how
> do you think, David?

No; it's a Blackfin-specific design flaw, one that I've not seen
in any other chip's GPIO support.  So it should stay in the Blackfin
support code.  (Possibly even specialized for the specific chips
which have that flaw/erratum.)

- Dave
