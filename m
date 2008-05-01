Return-Path: <linux-kernel-owner+w=401wt.eu-S1764003AbYEAVP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764003AbYEAVP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbYEAVPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:15:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755547AbYEAVPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:15:21 -0400
Date: Thu, 1 May 2008 14:15:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] lib: add ascii hex helper functions
Message-Id: <20080501141518.996edb65.akpm@linux-foundation.org>
In-Reply-To: <1209675067.24729.165.camel@brick>
References: <1209675067.24729.165.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 May 2008 13:51:07 -0700
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Everyone rolls their own version around the tree, centralize
> in lib/hexdump.c
> 
> +extern const char hex_asc[];
> +const char hexasc[16] = "0123456789abcdef";

If I were a compiler I'd get upset about that.

Honest, 24 hours really doesn't matter here.  Do it carefully, do
it right.
