Return-Path: <linux-kernel-owner+w=401wt.eu-S1764581AbYETOTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764581AbYETOTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932756AbYETOSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:18:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:37747 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932752AbYETOSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:18:45 -0400
Subject: Re: [PATCH 2/2] ftrace: support for PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: michael@ellerman.id.au
Cc: Steven Rostedt <rostedt@goodmis.org>, proski@gnu.org,
       a.p.zijlstra@chello.nl, sandmann@redhat.com, pq@iki.fi,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>, paulus@samba.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1211292277.7960.8.camel@localhost>
References: <20080515034942.109223655@goodmis.org>
	 <20080515035918.896765954@goodmis.org>  <1211292277.7960.8.camel@localhost>
Content-Type: text/plain
Date: Tue, 20 May 2008 10:17:39 -0400
Message-Id: <1211293059.8297.166.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Why do we not want to trace early boot? Just because it's not useful? 

Not running at the linked address... might be causing trouble.

Ben.


