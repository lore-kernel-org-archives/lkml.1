Return-Path: <linux-kernel-owner+w=401wt.eu-S1751483AbXFMUev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbXFMUev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbXFMUeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:34:44 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:3233 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751541AbXFMUen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:34:43 -0400
Message-ID: <467054EE.5010909@cfl.rr.com>
Date: Wed, 13 Jun 2007 16:34:54 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: Greg KH <greg@kroah.com>, linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Problem with http URL for stable git tree?
References: <46646389.7090101@am.sony.com> <20070604211359.GA2046@kroah.com> <466488C6.3070100@am.sony.com>
In-Reply-To: <466488C6.3070100@am.sony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jun 2007 20:34:52.0965 (UTC) FILETIME=[4BDE7D50:01C7ADFA]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15236.001
X-TM-AS-Result: No--9.272500-5.000000-4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird wrote:
> I'm behind a firewall that doesn't allow it.  Luckily, the
> firewall has some holes to allow me ssh access to a few
> external machines.  It looks like I can use a "git:" url on a
> box outside the firewall, then clone that to inside Sony
> with a "git+ssh:" url.
> 
> I'll do that, unless someone else has a better suggestion.
> Pushes and pulls will be two steps each, but at least it works.
>  -- Tim

I thought there was a switch somewhere to override the command executed 
on the other machine?  You could try pulling from the machine outside 
the firewall via ssh, and changing the command from git-upload-pack to 
another ssh command to connect to kernel.org and invoke git-upload-pack 
there.  That should bounce the connection off the one machine you can 
ssh to outside the firewall.
