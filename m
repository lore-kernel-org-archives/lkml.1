Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab0BCTXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:23:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab0BCTXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:23:41 -0500
Date: Wed, 3 Feb 2010 20:22:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>, roland@redhat.com,
       akpm@linux-foundation.org, hskinnemoen@atmel.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 4/14] avr32: use generic ptrace_resume code
Message-ID: <20100203192223.GA12039@redhat.com>
References: <20100202185755.GA3630@lst.de> <20100202185857.GD3630@lst.de> <20100203084737.6e01247b@siona> <20100203083611.GA29025@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203083611.GA29025@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03, Christoph Hellwig wrote:
>
> I don't think the flag clearing on PTRACE_KILL matters as the process
> is a zombie and almost gone anyway, it's more an artefact of the
> generic implementation that I wanted to mention.

Well, PTRACE_KILL doesn't necessarily kill the tracee. Only if the
tracee reported the signal or syscall, otherwise ->exit_code is
ignored.

OTOH I agree, probably the flag clearing on PTRACE_KILL doesn't
really matter beause PTRACE_KILL shouldn't be used at all.


The whole series looks "obviously good" to me, but of course
this is up to arch maintaners.

Oleg.

