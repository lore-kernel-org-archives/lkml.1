Return-Path: <linux-kernel-owner+w=401wt.eu-S1758436AbZKYJ2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbZKYJ2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbZKYJ2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:28:13 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:63383 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbZKYJ2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:28:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=J9srSxr4Uzv/YL/ga1dAuoqEjv2NznoQlsGxfHnwtuu0x7K2AwiE5D9L/uKilgGLFZ
         0f00kmhE57sCDNeaNzVmo2WzNXw2Y2sTopF/bmmuzRsqSlwV6x+GoqcU96VPMNEbhPgT
         miP9KMbecxlkMmSWLgmfpz6nrgk+DgFwIV4so=
MIME-Version: 1.0
From: eran liberty <eran.liberty@gmail.com>
Date: Wed, 25 Nov 2009 11:27:58 +0200
Message-ID: <ffc2b1d40911250127x7b3c3609qb99820d212a7a0ad@mail.gmail.com>
Subject: kobjects: mark cleaned up kobjects as unitialized
To: gregkh@suse.de, balajirrao@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg & Balaji,

After diving into the LDKM and failed to spot the point where you
actually un-initialize the 'state_initialized' of a kobject... and
since I have statically allocated object which trip over this very
same trap...

Google-ing for others who fell into this trap, I found your thread/patch at:
http://lkml.org/lkml/2008/3/8/155
and
http://lkml.indiana.edu/hypermail/linux/kernel/0902.0/01969.html

I noticed this patch did not make it into the mainline.

Is this patch still valid?
Is there some other, better way to do it by the book?

Right now I by-pass the problem by memset-ing the whole object after I
release it... but I feel this is a bit brutal.

-- Liberty
