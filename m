Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbXFOQVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbXFOQVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757334AbXFOQVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:21:17 -0400
Received: from terminus.zytor.com ([192.83.249.54]:40471 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331AbXFOQVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:21:15 -0400
Message-ID: <4672BC5B.1040502@zytor.com>
Date: Fri, 15 Jun 2007 09:20:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-Devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 03/10] define ELF notes for adding to a boot image
References: <20070615004818.424726597@goop.org> <20070615005012.882738673@goop.org>
In-Reply-To: <20070615005012.882738673@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> +#define EIN_PROGRAM_CHECKSUM	3 /* ip style checksum of the memory image. */

Why on earth use one of the weakest verificants in common use?

	-hpa
