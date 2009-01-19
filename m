Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbZASQbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbZASQbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 11:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZASQbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 11:31:04 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:33729 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbZASQbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 11:31:03 -0500
Date: Mon, 19 Jan 2009 17:32:46 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: Avoid using CONFIG_ in userspace visible headers
Message-ID: <20090119163246.GB10378@uranus.ravnborg.org>
References: <1232370050-7434-1-git-send-email-avi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232370050-7434-1-git-send-email-avi@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 03:00:50PM +0200, Avi Kivity wrote:
> Kconfig symbols are not available in userspace, and are not stripped by
> headers-install.  Avoid their use by adding #defines in <asm/kvm.h> to
> suit each architecture.
> 
> Signed-off-by: Avi Kivity <avi@redhat.com>

Looked through the patch and everything looked fine.

	Sam
