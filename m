Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbYCCShp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbYCCShp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYCCShe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:37:34 -0500
Received: from gv-out-0910.google.com ([216.239.58.189]:39747 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYCCShe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:37:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JyCltf9VX7MjyT4tGAWcNHHnmfSWNtjuTy8Y8CTLvcmpdAIgIAT7P97nDymVgr5o5n0njD0vdTofMlcAVZp+p5Tmd83Vei4U6DBO+mWTpdlaI3AaO6aeXtYqikGwAfsN149+QlmNf2i0uLGHAB7DWg/p6P31ZGYpRPxZ38FJ+5o=
Message-ID: <8bd0f97a0803031037v2b50ec99ubff5ce7f885a7778@mail.gmail.com>
Date: Mon, 3 Mar 2008 13:37:30 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH] blackfin: replace remaining __FUNCTION__ occurances
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1204568389.3266.23.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204568389.3266.23.camel@brick>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 1:19 PM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> __FUNCTION__ is gcc-specific, use __func__

gcc is the only Blackfin toolchain that can build the kernel, but the
change is fine in general
-mike
