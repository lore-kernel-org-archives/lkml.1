Return-Path: <linux-kernel-owner+w=401wt.eu-S2992696AbXDDGXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992696AbXDDGXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992697AbXDDGXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:23:14 -0400
Received: from smtp-out.google.com ([216.239.45.13]:59072 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992696AbXDDGXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:23:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=ltEnMirNGwj99c7XCQMEIbzejfSJdr9Ao2+tTyH8JiX5hhKZ++PkA4kGT+N0vxu5R
	EFFsEdI3A+1mmWbgXPP5A==
Date: Tue, 3 Apr 2007 23:22:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Mackall <mpm@selenic.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/13] maps: Make /proc/pid/clear_refs option under
 CONFIG_EMBEDDED
In-Reply-To: <12.486631555@selenic.com>
Message-ID: <Pine.LNX.4.64.0704032321360.27164@chino.kir.corp.google.com>
References: <12.486631555@selenic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Matt Mackall wrote:

> Make /proc/pid/clear_refs option under CONFIG_EMBEDDED
> 
> This interface is primarily useful for doing memory profiling and not
> much use on deployed embedded boxes. Make it optional. Together with
> /proc/pid/smaps, this save a few K.
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>

Acked-by: David Rientjes <rientjes@google.com>

Althought /proc/pid/clear_refs isn't actually useful without smaps as 
well, so you could make it depend on CONFIG_PROC_SMAPS.
