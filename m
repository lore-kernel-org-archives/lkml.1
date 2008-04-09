Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbYDIORS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbYDIORS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 10:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYDIORI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 10:17:08 -0400
Received: from colobus.isomerica.net ([216.93.242.10]:34676 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbYDIORH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 10:17:07 -0400
Message-ID: <47FCCF94.3000103@isomerica.net>
Date: Wed, 09 Apr 2008 10:15:48 -0400
From: Dan Noe <dpn@isomerica.net>
Reply-To: dpn@isomerica.net
Organization: isomerica.net
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Andreas Grimm <agrimm61@gmail.com>
CC: Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
Subject: Re: VM - a plenty of inactive memory
References: <cf40c6a90804090213u55491ceay9b211d75d74dc29c@mail.gmail.com>	 <874pabrx6b.fsf@saeurebad.de> <cf40c6a90804090657j7e76a84foeaf3c1c02d2a7b73@mail.gmail.com>
In-Reply-To: <cf40c6a90804090657j7e76a84foeaf3c1c02d2a7b73@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Grimm wrote:
> i know this. But why the kernel locks that memory for a so long time
> (2 days now)? Is there a way to enforce the reclaiming? And how can i
> find out, which process owns that memory. The problem is, that i can't
> accept, that the free memory fell down to 50MB, when i have 24GB in
> the nirvana. The system was recently very close to the awkward
> situation to swap to disk, and i bet it will do so in the next few
> days, because it happened before. Unintelligible, if one got that much
> ram.

Have you investigated the sys.vm.swappiness tunable?  It allows you to 
control how readily the kernel swaps out unused mapped memory.  This 
seems to be relevant to your issue.

See http://lwn.net/Articles/83588/

Cheers,
Dan

-- 
                     /--------------- - -  -  -   -   -
                     |  Daniel Noe
                     |  http://isomerica.net/~dpn/
