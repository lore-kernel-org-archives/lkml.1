Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYCWPVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYCWPVa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 11:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYCWPVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 11:21:21 -0400
Received: from n66.bullet.mail.sp1.yahoo.com ([98.136.44.50]:33379 "HELO
	n66.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750876AbYCWPVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 11:21:20 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Mar 2008 11:21:20 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 557504.58667.bm@omp402.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=tJW6dLrxOMjgsIEv+adCtFx67oDYL1FovsqIdB1Lfz9lhaCynX9/YhcDuzl6Q55WKODzYWTp7aJeYRm3vVX2Oeb71aVnFDUfweBkQF/WjNau2gdYaz87O4SAMfWrVBVm/TNPq5TgcSSnzT9mxewfZh3Hhojw4Kh2JH6BOE0Mvo8=;
X-YMail-OSG: 1tMF1E8VM1kwcj83WSt64jXQhfcp9tcjeyCapqeDvp3KGyKpRjrsbguc7xNSkvVbyluZuxpA0dURvVVhTWcvpiA6OA--
Date: Sun, 23 Mar 2008 08:15:59 -0700 (PDT)
From: "John T." <j.thomast@yahoo.com>
Subject: UTF-8 and Alt key in the console
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <348315.11787.qm@web45704.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It is understood that although the Meta-key sequences
work in an xterm with vim on UTF-8, they don't on the
linux console.

That's because vim and xterm have an understanding about
how to function in UTF-8 regarding the Meta key. Xterm
translates the would-be ISO-8859 high-bit-char to its
UTF-8 representation, and vim catches that. This is the
way to move the traditional 8th-bit Meta convention from
single-byte encodings to UTF-8.

The linux console could function that way too, so that the
Meta-key would be recognized for those not willing to make
Meta send an ESC prefix; this behavior can be toggled with
the setmetamode command. Seems it's quite a simple code
snippet.

I'd like to know whether it would be an accepted change.

Regards,
--
John


      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs

