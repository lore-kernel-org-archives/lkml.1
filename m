Return-Path: <linux-kernel-owner+w=401wt.eu-S1030301AbXCSQKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030301AbXCSQKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030332AbXCSQKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:10:11 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:44791 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030317AbXCSQKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:10:10 -0400
Message-ID: <45FEB50E.2040104@aitel.hist.no>
Date: Mon, 19 Mar 2007 17:06:38 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Avi Kivity <avi@argo.co.il>
CC: davids@webmaster.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: is RSDL an "unfair" scheduler too?
References: <MDEHLPKNGKAHNMBLJOLKGEMBCFAC.davids@webmaster.com> <45FEAB60.7090704@argo.co.il>
In-Reply-To: <45FEAB60.7090704@argo.co.il>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>
> A fairly contrived example, but I see your point.  Of course any 
> system can be broken.  I think that user-level scheduling is good for 
> real multi user systems, where 'user' means a person, not an 
> artificial entity.  It's also good for a multi application server, 
> where typically each service runs (or can be made to run) as a 
> separate user.
For a not so contrived example, look at email delivery.  Some mailservers do
all work as root (or some fixed email user)

Some servers will switch to the UID of the user receiving the message, 
limiting the
damage in case of buffer overflow etc. A fair amount of work is then done
as that user - running the message through virus/spam-checks and
then perhaps procmail.

Helge Hafting
