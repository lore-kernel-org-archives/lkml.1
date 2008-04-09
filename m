Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYDISIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYDISIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbYDISIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:08:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59977 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYDISIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:08:24 -0400
Message-ID: <47FD046C.6070804@zytor.com>
Date: Wed, 09 Apr 2008 11:01:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: sukadev@us.ibm.com
CC: linux-kernel@vger.kernel.org, Containers <containers@lists.osdl.org>,
       Pavel Emelyanov <xemul@openvz.org>, serue@us.ibm.com, clg@fr.ibm.com
Subject: Re: [RFC][PATCH 0/7] Clone PTS namespace
References: <20080408215333.GA8799@us.ibm.com> <47FC138B.4070408@zytor.com> <20080409162353.GA14044@us.ibm.com>
In-Reply-To: <20080409162353.GA14044@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sukadev@us.ibm.com wrote:
> We want to provide isolation between containers, meaning PTYs in container
> C1 should not be accessible to processes in C2 (unless C2 is an ancestor).

Yes, I certainly can understand the desire for isolation.  That wasn't 
what my question was about.

> The other reason for this in the longer term is for checkpoint/restart.
> When restarting an application we want to make sure that the PTY indices
> it was using is available and isolated.

OK, this would be the motivation for index isolation.

> A complete device-namespace could solve this, but IIUC, is being planned
> in the longer term. We are hoping this would provide the isolation in the
> near-term without being too intrusive or impeding the implementation of
> the device namespace.

I'm just worried about the accumulation of what feels like ad hoc 
namespaces, causing a very large combination matrix, a lot of which 
don't make sense.

	-hpa
