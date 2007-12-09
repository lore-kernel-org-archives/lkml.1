Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbXLIFtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbXLIFtF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 00:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbXLIFsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 00:48:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:20178 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbXLIFsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 00:48:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tmbnM6Y6AqzUMcqpevCJpIkx6e0XguAPTrvKxS4HY+185w+zrRz1QJtH4UiL6TjhvsMhDw3wKc0m/zBmSGOXsIRkq2oh0ZAl0sOXotQ1zn5If37T66EgHOl14WDNIL2mzKJfXfd3AexEmY/55aMW0L0mg6MrAzCmxYCZaMkJiXI=
Message-ID: <475B81C0.4050908@gmail.com>
Date: Sun, 09 Dec 2007 14:48:48 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jon Masters <jonathan@jonmasters.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] depmod: sort output according to modules.order
References: <47555AF1.8090304@gmail.com>  <47555C64.8070607@gmail.com> <1197100997.20786.156.camel@perihelion>
In-Reply-To: <1197100997.20786.156.camel@perihelion>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters wrote:
> On Tue, 2007-12-04 at 22:55 +0900, Tejun Heo wrote:
> 
>> Kbuild now generates and installs modules.order along with modules.
>> This patch updates depmod such that it sorts module list according to
>> the file before generating output files.  Modules which aren't on
>> modules.order are put after modules which are ordered by
>> modules.order.
> 
> Thanks. Please CC me in general on these patches :-)

Sure.  FYI, updated patchset is posted.

  http://thread.gmane.org/gmane.linux.kernel/611212

-- 
tejun
