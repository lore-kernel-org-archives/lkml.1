Return-Path: <linux-kernel-owner+w=401wt.eu-S1764503AbYJJUp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764503AbYJJUp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762012AbYJJUpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:45:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764261AbYJJUpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:45:15 -0400
Date: Fri, 10 Oct 2008 13:44:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Gadiyar, Anand" <gadiyar@ti.com>
Cc: johnpol@2ka.mipt.ru, linux-kernel@vger.kernel.org, madhu.cr@ti.com
Subject: Re: [PATCH 4/5] W1: Export w1_read_8 function
Message-Id: <20081010134410.094f349b.akpm@linux-foundation.org>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB02D6107AF6@dbde02.ent.ti.com>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02D6107AF6@dbde02.ent.ti.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2008 12:55:25 +0530
"Gadiyar, Anand" <gadiyar@ti.com> wrote:

> From: Madhusudhan Chikkature <madhu.cr@ti.com>
> 
> This patch exports the w1_read_8 function for use of drivers.
> 

The changelog should explain why the export is needed (eg: "used by the
foobar driver").

If, as I assume, this symbol is used by the HDQ driver then this patch
should be staged _ahead_ of those patches to avoid breaking
bisectability, and because that's generally a saner ordering.


