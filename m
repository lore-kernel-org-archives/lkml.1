Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbZGVNHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbZGVNHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbZGVNHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:07:46 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:58542 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbZGVNHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:07:46 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] perf_counter: Improve perf stat and perf record option
 parsing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Anton Blanchard <anton@samba.org>
Cc: mingo@elte.hu, paulus@samba.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090722130412.GD9029@kryten>
References: <20090722130412.GD9029@kryten>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 15:08:55 +0200
Message-Id: <1248268135.27058.1414.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 23:04 +1000, Anton Blanchard wrote:
> perf stat and perf record currently look for all options on the command
> line. This can lead to some confusion:
> 
> # perf stat ls -l
>   Error: unknown switch `l'
> 
> While we can work around this by adding '--' before the command, the git
> option parsing code can stop at the first non option:
> 
> # perf stat ls -l
>  Performance counter stats for 'ls -l':
> ....
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

I queued it, thanks Anton.

