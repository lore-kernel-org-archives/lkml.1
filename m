Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbZD0VC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbZD0VC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 17:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbZD0VCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 17:02:48 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:48891 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457AbZD0VCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 17:02:48 -0400
Date: Mon, 27 Apr 2009 16:51:05 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: David Rientjes <rientjes@google.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Replace the watermark-related union in struct zone with
 a watermark[] array
In-Reply-To: <20090427205400.GA23510@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0904271650280.1467@qirst.com>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie> <1240408407-21848-19-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.0904221251350.14558@chino.kir.corp.google.com> <20090427170054.GE912@csn.ul.ie> <alpine.DEB.2.00.0904271340320.11972@chino.kir.corp.google.com>
 <20090427205400.GA23510@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009, Mel Gorman wrote:

> Would people prefer a getter/setter version?

I'd say leave it as is. It unifies the usage of the watermark array.

