Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbYLHT2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbYLHT2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 14:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYLHT2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 14:28:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:57591 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYLHT2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 14:28:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=D8EtlHSMHACS6krEtirui6S5VM2E35ZynO9gn38a0KCCDSD/n1aliWsO/KdtTA21Nj
         fayuI8pmtD+3d+qgPO6gzwN7tYxUVCwVg09rg/yEbjI6VHWx6ZF0VibLeo+z7txEn8h1
         ncyXlhKMmdvL8RnUx2Fp1ZFzY13lcYU/6+4Bo=
Message-ID: <84144f020812081128p6d1e2a55v69996a360e7f0e8f@mail.gmail.com>
Date: Mon, 8 Dec 2008 21:28:04 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Dennis Hardy" <dhardy@sogetthis.com>
Subject: Re: CIFS regression in 2.6.27.8
Cc: linux-kernel@vger.kernel.org, layton@redhat.com,
       "Steven French" <sfrench@us.ibm.com>, "Greg KH" <gregkh@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20900699.post@talk.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20900699.post@talk.nabble.com>
X-Google-Sender-Auth: c1bcc7dbf9fae9be
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dennis,

On Mon, Dec 8, 2008 at 8:18 PM, Dennis Hardy <dhardy@sogetthis.com> wrote:
> I just mounted a network drive (Windows Server) via CIFS under 2.6.27.8, and
> the sizes reported by "df" are completely incorrect:
>
>  root@exodus:~# df -h /mnt/fsv1
>  Filesystem            Size  Used Avail Use% Mounted on
>  //fsv1/Users          446G -222G  667G   -  /mnt/fsv1
>  root@exodus:~# df /mnt/fsv1
>  Filesystem           1K-blocks      Used Available Use% Mounted on
>  //fsv1/Users         467403140 -231816588 699219728   -  /mnt/fsv1
>  root@exodus:~# mount | grep fsv1
>  //fsv1/Users on /mnt/fsv1 type cifs (rw,mand)
>  root@exodus:~#
>
> Does anyone else see this sort of behavior with 2.6.27.8?  This worked fine
> in 2.6.27.6 (we skipped 2.6.27.7)...
>
> Ideas?

Well, lets cc the relevant people so your report isn't lost in the noise.
