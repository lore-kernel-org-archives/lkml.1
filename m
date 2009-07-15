Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbZGOLMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbZGOLMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 07:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbZGOLMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 07:12:41 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:44305 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbZGOLMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 07:12:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lGO8sPx5mznG/Buy35w7kONUT7W+1Tg0i0ORhy4lx6n4kiANxxnvthOeAONP2j/ZKU
         bVunX+3760j9Cl9CA3AAMN7Sc+3zk8JpROMwdC9O8+sJ7HSRLFYcLkjIvu7ifSSlQk6I
         pQBq4/7C0k7J5hjMYc+wBsq3KL79lcx5lwhNc=
MIME-Version: 1.0
In-Reply-To: <12377.1247654255@redhat.com>
References: <1247591665-12000-1-git-send-email-vapier@gentoo.org> 
	<20090714161416.GA19147@cmpxchg.org> <6206.1247592126@redhat.com> 
	<4A5CFFD8.7020106@t-online.de> <12377.1247654255@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 15 Jul 2009 07:12:20 -0400
Message-ID: <8bd0f97a0907150412h234cf4d6l439d92d832055373@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH v2] NOMMU: add support for Memory 
	Protection Units (MPU)
To: David Howells <dhowells@redhat.com>
Cc: Bernd Schmidt <bernds_cb1@t-online.de>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 06:37, David Howells wrote:
> Bernd Schmidt <bernds_cb1@t-online.de> wrote:
>> No page table, just three bitmaps (r/w/x), with one bit per page, per mm.
>
> I presume that all you do is maintain a distinction between
> userspace-accessible areas and kernel-only areas, and don't prevent userspace
> processes from destroying each other.

there is full 4k page protection between processes and between the
kernel and processes.
-mike
