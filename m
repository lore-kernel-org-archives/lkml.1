Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbXE0USB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbXE0USB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 16:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbXE0URy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 16:17:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:13266 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbXE0URx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 16:17:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ZQI//ruHqnu7HjAfxk95fp+//0/pAvoe6Bav+ZyS3EC4OSmLyeyrfHC4tSwXKAJ9n3Q8Zs4nOWZQgNVAckoLNMqsbfSi2qS/PweJpuK7EJ+ExQn02tbSX118nv5PxtdwlXtyfNFS7Q+Z3CWb3H06t37/BL9sljs+1it/9HeVR4M=
Message-ID: <84144f020705271317q3e46fd88u58058686edf71829@mail.gmail.com>
Date: Sun, 27 May 2007 23:17:51 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH 2/2] [condingstyle] Add chapter on tests
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <4659C828.80503@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070525172509.5138.56430.stgit@localhost.localdomain>
	 <20070525172515.5138.13652.stgit@localhost.localdomain>
	 <Pine.LNX.4.61.0705262121150.7344@yvahk01.tjqt.qr>
	 <4659C828.80503@intel.com>
X-Google-Sender-Auth: 993f5f8bde25e61c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/27/07, Kok, Auke <auke-jan.h.kok@intel.com> wrote:
> that piece is a copy of mm/slab.c, and all over the core components of the
> kernel (even fs/inode.c written by Linus). I strongly think that "== NULL"
> doesn't add anything and that well-written functions and well-named variables
> really do not need the extra fluff.

Yup, I we really don't use "== NULL" in core code that much. But I am
not convinced this should be in CodingStyle either. It's more of a
maintainer preference thing above all.
