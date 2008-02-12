Return-Path: <linux-kernel-owner+w=401wt.eu-S1764199AbYBLTp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764199AbYBLTp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756950AbYBLTpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:45:32 -0500
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:30599 "HELO
	web31812.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752791AbYBLTpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:45:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=Qfm2p+4YOJm7WDtmvfAaJ1iCqd/7PpsPUf+l14Bu11cvtFQ23pSjle+BixydV6RsVuwXpnJ9gq7pjAtgvZfwk/iguTIuQ3MRQT0+DgK97qkqM/ss8CLlA7vVgQaW9+eWLIO+4zDSRXyxlXc4iTDrd7BFAR5KFCiK1EsIr63p0IQ=;
X-YMail-OSG: XLU1YD4VM1mYnQ9JR1f0vn4zQxLxzhPuXkd40096f1A8rnxun0xe.zXnbxk0xeX207oD5A--
X-Mailer: YahooMailWebService/0.7.162
Date: Tue, 12 Feb 2008 11:45:29 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] enclosure: add support for enclosure services
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, jeff@garzik.org
In-Reply-To: <20080212102244.32869382@appleyard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <608362.85432.qm@web31812.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Tue, 2/12/08, Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:
> Hi,
> I apologize for taking so long to review this patch.  I
> obviously agree
> wholeheartedly with Luben.  The problem I ran into while
> trying to
> design an enclosure management interface for the SATA
> devices is that
> there is all this vendor defined stuff.  For example, for
> the AHCI LED
> protocol, the only "defined" LED is
> 'activity'.  For LED2 and LED3 it
> is up to hardware vendors to define these.  For SGPIO
> there's all kinds
> of ways for hw vendors to customize.  I felt that it was
> going to be a
> maintainance nightmare to have to keep track of various
> vendors
> enclosure implementations in the ahci driver, and that
> it'd be better
> to just have user space libraries take care of that.  Plus,
> that way a
> vendor doesn't have to get a patch into the kernel to
> get their new
> spiffy wizzy bang blinky lights working (think of how long
> it takes
> something to even get into a vendor kernel, which is what
> these guys
> care about...).  So I'm still not sold on having an
> enclosure
> abstraction in the kernel - at least for the SATA
> controllers.

And I agree wholeheartedly with Kristen.

   Luben

