Return-Path: <linux-kernel-owner+w=401wt.eu-S1752761AbYJ0FRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbYJ0FRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 01:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYJ0FRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 01:17:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:49952 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbYJ0FRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 01:17:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=hDKblVjgHXBb9w28UFEM5o2JGUZLX2zcon00fzQDEgBJr/hFVryCO2UrN5ycAh9+IC
         QekDZvVmYJWoIPKWQqsmM3PzWClliAFqebGFmjspeQQE7AwqInL6JHYoxRHOwxqgSc69
         guN0XeiyZWU0W21CTtApsiVbW7dwWI2bvIIIg=
Message-ID: <86802c440810262217h13f78e57l1f234e8e86b72785@mail.gmail.com>
Date: Sun, 26 Oct 2008 22:17:22 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Diego M. Vadell" <dvadell@linuxclusters.com.ar>
Subject: Re: PAT and MTRRs
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <200810262246.21807.dvadell@linuxclusters.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810262246.21807.dvadell@linuxclusters.com.ar>
X-Google-Sender-Auth: be7d40a9daa35a74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 4:46 PM, Diego M. Vadell
<dvadell@linuxclusters.com.ar> wrote:
> Hello,
>
>   I have 6 identical PCs (HPC cluster) with MTRR problems. In older kernels,
> I had to use "mem=3300M", or else, I would get a very slowly boot (as when
> you run out of MTRRs).

can you try 2.6.28-rc2 ot tip/master and boot with mtrr_cleanup_debug ?

YH
