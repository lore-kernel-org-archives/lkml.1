Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYDRWOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYDRWOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 18:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYDRWOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 18:14:34 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:32475 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYDRWOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 18:14:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=MHTgo1GO8UDYwrWmM4/9RWu/91Hsoyk72AnoNFHCyBivClqiox1qtXlu8R2aRbdN+r7NlQhGB+4MPRHiziuSQ65gU0Qnfsh8jy2pmV91ZV9HWuND419fOhjJmqcAsGe1tjm9OE0ewNhzehQwgdwOv8jXff5Tt3AntGar1ZmD4M8=
Date: Sat, 19 Apr 2008 03:09:59 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: 2.6.25-mm1: orphaned files after build
Message-ID: <20080418230959.GA8445@martell.zuzino.mipt.ru>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least the following files aren't removed by "make mrproper":

	Module.markers
	arch/x86/kernel/acpi/realmode/wakeup.lds
	crypto/.tmp_aes_generic.ver
	fs/.tmp_buffer.ver
	kernel/time/.tmp_timekeeping.ver

Noticed by "git-ls-files -o".

*.ver , I think, remain after abruptdly terminated build.

