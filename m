Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbZJUVKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbZJUVKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbZJUVKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:10:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbZJUVKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:10:10 -0400
Date: Wed, 21 Oct 2009 17:08:35 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, esandeen@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Unnecessary overhead with stack protector.
Message-ID: <20091021170835.6cd9bd52@katamari.usersys.redhat.com>
In-Reply-To: <4ADF5FE2.7070604@redhat.com>
References: <20091015183540.GA8098@redhat.com>
	<20091015190720.GA19467@elte.hu>
	<4ADF2DAA.9030604@redhat.com>
	<20091021110053.26ab9982@infradead.org>
	<4ADF59F8.7010205@redhat.com>
	<4ADF5C6B.80605@redhat.com>
	<4ADF5FE2.7070604@redhat.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009 14:24:18 -0500
Eric Sandeen <sandeen@redhat.com> wrote:

> 
> Forgive me if I'm not using the right tools to look, but it seems to me
> that in the aggregate, CC_STACKPROTECTOR_ALL has a pretty big impact.

FWIW, I think we'll end up either disabling the stackprotector completely
in Fedora, or at least reverting the patch that adds all that overhead.
