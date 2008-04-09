Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbYDIA5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbYDIA5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 20:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYDIA5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 20:57:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51759 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbYDIA5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 20:57:45 -0400
Message-ID: <47FC138B.4070408@zytor.com>
Date: Tue, 08 Apr 2008 17:53:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: sukadev@us.ibm.com
CC: linux-kernel@vger.kernel.org, Containers <containers@lists.osdl.org>,
       Pavel Emelyanov <xemul@openvz.org>, serue@us.ibm.com, clg@fr.ibm.com
Subject: Re: [RFC][PATCH 0/7] Clone PTS namespace
References: <20080408215333.GA8799@us.ibm.com>
In-Reply-To: <20080408215333.GA8799@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sukadev@us.ibm.com wrote:
> Devpts namespace patchset
> 
> In continuation of the implementation of containers in mainline, we need to
> support multiple PTY namespaces so that the PTY index (ie the tty names) in
> one container is independent of the PTY indices of other containers.  For
> instance this would allow each container to have a '/dev/pts/0' PTY and
> refer to different terminals.
> 

Why do we "need" this?  There isn't a fundamental need for this to be a 
dense numberspace (in fact, there are substantial reasons why it's a bad 
idea; the only reason the namespace is dense at the moment is because of 
the hideously bad handing of utmp in glibc.)  Other than indicies, this 
seems to be a more special case of device isolation across namespaces, 
would that be a more useful problem to solve across the board?

	hpa
