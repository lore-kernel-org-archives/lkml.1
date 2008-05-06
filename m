Return-Path: <linux-kernel-owner+w=401wt.eu-S932448AbYEFRs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbYEFRs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbYEFRsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:48:14 -0400
Received: from relay2.sgi.com ([192.48.171.30]:37377 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752792AbYEFRsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:48:12 -0400
Date: Tue, 6 May 2008 10:48:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: make vmstat cpu-unplug safe
In-Reply-To: <20080506154938.AC6B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0805061047290.23336@schroedinger.engr.sgi.com>
References: <20080506154938.AC6B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008, KOSAKI Motohiro wrote:
 
> btw: I think all_vm_event() author is Cristoph Lameter, right?

Welll I am the last one who reworked it from earlier incarnations.

> When access cpu_online_map, We should prevent that dynamically 
> change cpu_online_map by get_online_cpus().
> 
> Unfortunately, all_vm_events() doesn't it.

Acked-by: Christoph Lameter <clameter@sgi.com>
