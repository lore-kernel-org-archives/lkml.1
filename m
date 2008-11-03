Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbYKCT4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbYKCT4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYKCT4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:56:09 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:11352 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbYKCT4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:56:08 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] Identify which executable object the userspace address
 belongs to. Store thread group leader id, and use it to lookup the address
 in the process's map. We could have looked up the address on thread's map,
 but the thread might not exist by the time we are called. The process might
 not exist either, but if you are reading trace_pipe, that is unlikely.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>
Cc: mingo@elte.hu, srostedt@redhat.com, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
In-Reply-To: <1225660694-19765-3-git-send-email-edwintorok@gmail.com>
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com>
	 <1225660694-19765-2-git-send-email-edwintorok@gmail.com>
	 <1225660694-19765-3-git-send-email-edwintorok@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 20:56:29 +0100
Message-Id: <1225742189.7803.1631.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fwiw, this is one amazing subject line.. ;-)

