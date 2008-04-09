Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbYDIWjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbYDIWjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 18:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYDIWj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 18:39:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42665 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbYDIWj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 18:39:28 -0400
Message-ID: <47FD4550.1010700@zytor.com>
Date: Wed, 09 Apr 2008 15:38:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: serge@hallyn.com
CC: sukadev@us.ibm.com, linux-kernel@vger.kernel.org,
       Containers <containers@lists.osdl.org>,
       Pavel Emelyanov <xemul@openvz.org>, serue@us.ibm.com, clg@fr.ibm.com
Subject: Re: [RFC][PATCH 0/7] Clone PTS namespace
References: <20080408215333.GA8799@us.ibm.com> <47FC138B.4070408@zytor.com> <20080409162353.GA14044@us.ibm.com> <47FD046C.6070804@zytor.com> <20080409191634.GA25220@vino.hallyn.com>
In-Reply-To: <20080409191634.GA25220@vino.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

serge@hallyn.com wrote:
>> I'm just worried about the accumulation of what feels like ad hoc 
>> namespaces, causing a very large combination matrix, a lot of which don't 
>> make sense.
> 
> Hmm, if we were to just call this CLONE_NEWDEV, would that (a) make
> sense and (b) suitably address your (certainly valid) concern?
> 
> Basically for now CLONE_NEWDEV wouldn't yet be fully implemented, only
> unsharing unix98 ptys...

That would make sense to me.  Also see Eric's note about uevent, 
however; and there are probably other issues like it.

	-hpa
