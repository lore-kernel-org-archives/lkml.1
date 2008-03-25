Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbYCYVlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbYCYVlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760474AbYCYVi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:38:29 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:14606 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757735AbYCYVi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:38:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VIFK7eF7Mge4LsqGkpOjxGWWmu2vl3i7ytLPcoOEz82E3gzh7gKxgcDqHD1ZntpY9MhVlz1h2TkJd5wi2ktk7pm84eJnmfAIiRCmKJAkMueI80wSI/6ZXa9aj/dEfFjmiHx1o3wExWUX3seZIytYwhyvBR0IcgK10cje7YujDcA=
Message-ID: <84144f020803251438j4896d587j917fece9421a1222@mail.gmail.com>
Date: Tue, 25 Mar 2008 23:38:26 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Oliver Pinter" <oliver.pntr@gmail.com>
Subject: Re: [PATCH] list_add corruption in slab.c
Cc: "Daniel Yeisley" <dan.yeisley@unisys.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, "Christoph Lameter" <clameter@sgi.com>, mel@csn.ul.ie
In-Reply-To: <6101e8c40803251427t777b0afdlf9e49e36b193c729@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206464258.13473.11.camel@localhost.localdomain>
	 <84144f020803251145m6672e0acv16d27aaae1acb4d9@mail.gmail.com>
	 <1206477858.8810.3.camel@localhost.localdomain>
	 <47E96B0A.2010906@cs.helsinki.fi>
	 <6101e8c40803251427t777b0afdlf9e49e36b193c729@mail.gmail.com>
X-Google-Sender-Auth: ec2a121d009740f6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

On Tue, Mar 25, 2008 at 11:27 PM, Oliver Pinter <oliver.pntr@gmail.com> wrote:
>  this patch for 2.6.22?

No. It fixes the following commit which is not in nor is it required for 2.6.22:

  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=556a169dab38b5100df6f4a45b655dddd3db94c1
