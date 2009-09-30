Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZI3WUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZI3WUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 18:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZI3WUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 18:20:03 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:51925 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbZI3WUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 18:20:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAEJ1w0rCTtAn/2dsb2JhbACBUdZ4hCcE
Date: Thu, 1 Oct 2009 00:19:58 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] vfat and
	Simon_&_Garfunkel-Wednesday_Morning,_3_a.m.
Message-ID: <20090930221957.GA31007@frolo.macqel>
References: <20090319181120.GA18034@frolo.macqel> <20090323085024.GA8897@frolo.macqel> <20090323140005.GB25840@frolo.macqel> <20090925194636.GA15700@frolo.macqel> <87vdj2ysk8.fsf@devron.myhome.or.jp> <20090929102559.GA4590@frolo.macqel> <20090929224340.GA9730@frolo.macqel> <87ljjwzoeu.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ljjwzoeu.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 08:02:01PM +0900, OGAWA Hirofumi wrote:
> Philippe De Muyter <phdm@macqel.be> writes:
> 
> >> > IIRC, Windows stripped the trailing ".". That filename can be read/used on
> >> > Windows?
> >> 
> >> Sorry I don't use MS-Windows.  I'll try to find someone who does.
> >
> > MS-Windows (XP SP3) lists correctly the names with their trailing dots.
> 
> Ok. Is it meaning you could read the file correctly? I guess so, and
> I'll review deeply about dcache issues for it.

Sorry. I did not test enough yesterday. It was late  :/

on MS-Windows XP SP#, the files and directories are listed with their
real name, including the trailing dots, but if one tries to open such a
file or go into such a directory, that fails with an error message.

With a "123456789." file :
Cannot find the E:\PUBLIC\trailing_dots\123456789. file.
Do you want to create a new file?
		Yes		No		Cancel

With a "directoryname." directory :
E\PUBLIC\trailing_dots\directoryname. refers to a location that is unavailable.
It could be on a hard drive on this computer, or on a network. Check to make
sure that the disk is properly inserted, or that you are connected to the
Internet or your network, and then try again.  If it still cannot be located,
the information might have been moved to a different location.
				OK

I don't think we want linux to remain compatible with this bug.  So perhaps
not removing the trailing dots for a lookup is all what is needed.

Best regards

Philippe
