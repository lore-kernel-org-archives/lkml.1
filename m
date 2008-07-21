Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbYGUOFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbYGUOFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 10:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbYGUOFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 10:05:32 -0400
Received: from stinky.trash.net ([213.144.137.162]:38366 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbYGUOFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 10:05:31 -0400
Message-ID: <488497AA.7000407@trash.net>
Date: Mon, 21 Jul 2008 16:05:30 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Ranjit Manomohan <ranjitm@google.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, menage@google.com
Subject: Re: [PATCH 2/2] Traffic control cgroups subsystem
References: <Pine.LNX.4.64.0807181428180.18212@ranjit.corp.google.com>
In-Reply-To: <Pine.LNX.4.64.0807181428180.18212@ranjit.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ranjit Manomohan wrote:
> This patch implements a filter that classifies packets based upon
> the cgroup_classid of the packet.

I'd suggest to add this to the flow classifier (cls_flow.c),
adding a full classifier is overkill just for this one field.
