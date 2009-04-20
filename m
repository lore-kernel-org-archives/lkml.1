Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbZDTJSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbZDTJSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 05:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbZDTJSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 05:18:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50766 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbZDTJSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 05:18:42 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Eric B Munson <ebmunson@us.ibm.com>
Subject: Re: [PATCH V3] Fix Committed_AS underflow
Cc: kosaki.motohiro@jp.fujitsu.com, dave@linux.vnet.ibm.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       mel@linux.vnet.ibm.com, cl@linux-foundation.org
In-Reply-To: <1240218590-16714-1-git-send-email-ebmunson@us.ibm.com>
References: <1240218590-16714-1-git-send-email-ebmunson@us.ibm.com>
Message-Id: <20090420181617.61B1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 20 Apr 2009 18:18:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch makes a small change to an earlier patch by Kosaki Motohiro.
> The threshold calculation was changed to avoid the overhead of calculating
> the number of online cpus each time the threshold is needed.

IIRC, Mel have the patch of kill num_online_cups() calculation cost.
but I can accept your patch because mel patch haven't merged mainline yet.

Thanks :)



