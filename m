Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667Ab0ASQ5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab0ASQ5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 11:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628Ab0ASQ5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 11:57:38 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:44209 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab0ASQ5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 11:57:37 -0500
Date: Tue, 19 Jan 2010 10:56:00 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 02/37] x86: check range in update range
In-Reply-To: <1263611228-6751-3-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.00.1001191055070.22304@router.home>
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org> <1263611228-6751-3-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jan 2010, Yinghai Lu wrote:

> fend off wrong range

Why is it ok now to call these functions with start >= end? Bootmem
compatibilty?

