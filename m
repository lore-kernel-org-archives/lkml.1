Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbYDGS5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbYDGS5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 14:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYDGS46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 14:56:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:7744 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbYDGS45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 14:56:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=iJNrm1mqvn44KWRq88pXEeMkvS23XzJqZ5fSbYhlAvXtshOTM1D6UuJKacSNJ7x0xJ1ZD7Ay8YBfkk5JwfH/HQe66oXkbL6Bub1WR0OyOL8GVMFSOXH3tY7zK8J67fucshFdx4yIaQW/PcMGpzJiVPzQygZyZGLvNF258cLoCl0=
Date: Mon, 7 Apr 2008 22:56:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: bootmem allocator
Message-ID: <20080407185613.GD9211@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Peter,

small question. It was a patch recently posted which removes
memset(x, 0, x) after __alloc_bootmem call. There are a few another
code snippets who still call memset(x, 0, x). And who is responsible for
memory clearing? bootmem allocator or caller?

		- Cyrill -
