Return-Path: <linux-kernel-owner+w=401wt.eu-S1751842AbZLTHs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbZLTHs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 02:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbZLTHs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 02:48:27 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:41637 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbZLTHs0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 02:48:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tNWwv3/iB1u+Sv80Bw/NVRQDeVO6O+DKR5Wm8i4Y0yw96v5O8HTlAIAG11VA7VpPgY
         rxwJaFRnd4yVD1K3rgm0l/S/sQ4ptTtmZ17Afd0J1zmBGaMxIO62Ht8eXmeRIa6VZ68y
         40yBCYkkCF4RF66bhEb3z1HdbgfL3HEjOli+I=
MIME-Version: 1.0
In-Reply-To: <200912192140.nBJLeSfA028905@hs20-bc2-1.build.redhat.com>
References: <200912192140.nBJLeSfA028905@hs20-bc2-1.build.redhat.com>
Date: Sun, 20 Dec 2009 09:48:24 +0200
X-Google-Sender-Auth: 5c34e9a0b730dad8
Message-ID: <84144f020912192348x78ee0716x3ef24d8a9d72de3c@mail.gmail.com>
Subject: Re: perf: A few more directory handling optimizations
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ulrich Drepper <drepper@redhat.com>
Cc: a.p.zijlstra@chello.nl, acme@redhat.com, eranian@google.com,
       fweisbec@gmail.com, linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       mingo@elte.hu, paulus@samba.org, xiaoguangrong@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 19, 2009 at 11:40 PM, Ulrich Drepper <drepper@redhat.com> wrote:
> A few more optimizations for perf when dealing with directories.  Some of
> them significantly cut down the work which has to be done.  d_type should
> always be set; otherwise fix the kernel code.  And there are functions
> available to parse fstab-like files, so use them.
>
> Signed-off-by: Ulrich Drepper <drepper@redhat.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
