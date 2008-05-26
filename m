Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbYEZS0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbYEZS0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 14:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbYEZS0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 14:26:09 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:58395 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbYEZS0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 14:26:08 -0400
Message-ID: <483B0077.7000207@linux.vnet.ibm.com>
Date: Mon, 26 May 2008 23:54:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm 00/16] VM pageout scalability improvements (V8)
References: <20080523195506.084894989@redhat.com>
In-Reply-To: <20080523195506.084894989@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On large memory systems, the VM can spend way too much time scanning
> through pages that it cannot (or should not) evict from memory. Not
> only does it use up CPU time, but it also provokes lock contention
> and can leave large systems under memory presure in a catatonic state.

Hi, Rik,

This patchset looks good (I did a brief scan). I'll go ahead and play with it?
What is a good memory size to test the patches on (to see improvements).


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
