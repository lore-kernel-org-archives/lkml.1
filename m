Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbZJAKmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbZJAKmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 06:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbZJAKmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 06:42:10 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:51559 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbZJAKmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 06:42:09 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] vfat and Simon_&_Garfunkel-Wednesday_Morning,_3_a.m.
References: <20090319181120.GA18034@frolo.macqel>
	<20090323085024.GA8897@frolo.macqel>
	<20090323140005.GB25840@frolo.macqel>
	<20090925194636.GA15700@frolo.macqel>
	<87vdj2ysk8.fsf@devron.myhome.or.jp>
	<20090929102559.GA4590@frolo.macqel>
	<20090929224340.GA9730@frolo.macqel>
	<87ljjwzoeu.fsf@devron.myhome.or.jp>
	<20090930221957.GA31007@frolo.macqel>
Date: Thu, 01 Oct 2009 19:42:09 +0900
In-Reply-To: <20090930221957.GA31007@frolo.macqel> (Philippe De Muyter's
	message of "Thu, 1 Oct 2009 00:19:58 +0200")
Message-ID: <87bpkrz98e.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter <phdm@macqel.be> writes:

> Sorry. I did not test enough yesterday. It was late  :/
>
> on MS-Windows XP SP#, the files and directories are listed with their
> real name, including the trailing dots, but if one tries to open such a
> file or go into such a directory, that fails with an error message.
>
> With a "123456789." file :
> Cannot find the E:\PUBLIC\trailing_dots\123456789. file.
> Do you want to create a new file?
> 		Yes		No		Cancel
>
> With a "directoryname." directory :
> E\PUBLIC\trailing_dots\directoryname. refers to a location that is unavailable.
> It could be on a hard drive on this computer, or on a network. Check to make
> sure that the disk is properly inserted, or that you are connected to the
> Internet or your network, and then try again.  If it still cannot be located,
> the information might have been moved to a different location.
> 				OK
>
> I don't think we want linux to remain compatible with this bug.  So perhaps
> not removing the trailing dots for a lookup is all what is needed.

I think to make that filename readable is not crazy, however it would be
the part of design.

And I found one issue for now, fs has to check existant file to make new
file. But if lookup and creation was using different name, the check can
not be done with that patch correctly.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
