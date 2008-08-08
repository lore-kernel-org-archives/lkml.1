Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbYHHEd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYHHEd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 00:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbYHHEdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 00:33:19 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:42769 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbYHHEdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 00:33:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=SGJsea5+TuexiAbCgSoGrMxghIxGLTXH19dmNDNTASOXTWICiDGftUto0pz7LkxjdO
         IjmrNYX2+W4IZPfyHjMadSuj3Nt0xWXJlvhD5DzJB9Cr4PJScEtmty/mSn3bGJ7x588g
         8ezCdW/wnRR35ARmnfxkAPyS5AtLP278wxaLY=
Message-ID: <82e4877d0808072133q58150665r355c9bf140d0b42c@mail.gmail.com>
Date: Fri, 8 Aug 2008 00:33:18 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: jmerkey@wolfmountaingroup.com
Subject: Re: [ANNOUNCE] mdb-2.6.27-rc2-ia32-08-07-08.patch
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

This definitely looks interesting and it even worked for me - breaking
in couple of times, trying various commands and resuming back to X all
works. Never tried a kernel debugger before but most things were
obvious after I figured out that I need to be on the VT to be able to
press break and be dropped into the debugger.

That said, it triggers soft lockups on all the suspended CPUs - not a
big deal and probably expected, but I guess that can be cured by
touching the soft lockup watch dog or something?

Thanks

Parag
