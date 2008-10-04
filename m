Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbYJDTpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbYJDTpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 15:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYJDTpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 15:45:35 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:35391 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYJDTpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:45:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bdmAAN5RWXfssYAk0ZTpKjqVN+kS7BpnwipDGyRsQvHWH6rM1nY0ZgfPyFRJ3DPL4c
         nvaTbfQ/4fBVSRuhIMmex24GgStvX4opf25RUideo8NugZWqrnSCqE1E03NOnNvOH8Fw
         cUXEo5HgcdM280YhOr/CbP+7kZcfvjlLwOZws=
Message-ID: <5d9b736f0810041245g4f05326sdf98e9d86472f874@mail.gmail.com>
Date: Sat, 4 Oct 2008 21:45:31 +0200
From: "Michal Januszewski" <michalj@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] fbdev: ignore VESA modes if framebuffer does not support them
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       krzysztof.h1@poczta.fm, bonbons@linux-vserver.org, hpa@zytor.com
In-Reply-To: <20081002234011.51ad28b1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080928125414.GA27703@spock.one.pl>
	 <20081002234011.51ad28b1.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2008 at 08:40, Andrew Morton <akpm@linux-foundation.org> wrote:

> -mm's efifb-imacfb-consolidation-hardware-support.patch removed FB_IMAC
> and moved it into FB_EDD.  But your patch changes FB_IMAC and not
> FB_EDD, so I don't know what needs to be done here.

I had a look at that patch and it looks like simply dropping the FB_IMAC
part from my patch is correct (i.e. the version of
fbdev-ignore-vesa-modes-if-framebuffer-does-not-support-them
that is currently in -mm is fine).

Best regards,
-- 
Michal Januszewski, Gentoo Linux Developer
http://people.gentoo.org/spock
