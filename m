Return-Path: <linux-kernel-owner+w=401wt.eu-S1751697AbZEEEqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbZEEEqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 00:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbZEEEqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 00:46:06 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:63487 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZEEEqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 00:46:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eZlNS230Ljtm3DTa6XIry4broa6BnmD9ugAwbg/9jjMpj3H9WnmN6Pi7f/YylaUQIz
         hb+7VgcTkP3gVNM76MD6C09d4WTn7WB0sMbgl4OkTJjodldKZt/UpWJRODdp2v4zTVPX
         BiU+Xv1z7TCKWZ4exxAMzneRylvVvy9CdzGGg=
Message-ID: <49FFC489.6080402@gmail.com>
Date: Mon, 04 May 2009 22:46:01 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Matthias Saou 
	<thias@spam.spam.spam.spam.spam.spam.spam.egg.and.spam.freshrpms.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Wrong network usage reported by /proc
References: <20090504171408.3e13822c@python3.es.egwn.lan>
In-Reply-To: <20090504171408.3e13822c@python3.es.egwn.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Saou wrote:
> Hi,
> 
> I'm posting here as a last resort. I've got lots of heavily used RHEL5
> servers (2.6.18 based) that are reporting all sorts of impossible
> network usage values through /proc, leading to unrealistic snmp/cacti
> graphs where the outgoing bandwidth used it higher than the physical
> interface's maximum speed.
> 
> For some details and a test script which compares values from /proc
> with values from tcpdump :
> https://bugzilla.redhat.com/show_bug.cgi?id=489541
> 
> The values collected using tcpdump always seem realistic and match the
> values seen on the remote network equipments. So my obvious conclusion
> (but possibly wrong given my limited knowledge) is that something is
> wrong in the kernel, since it's the one exposing the /proc interface.
> 
> I've reproduced what seems to be the same problem on recent kernels,
> including the 2.6.27.21-170.2.56.fc10.x86_64 I'm running right now. The
> simple python script available here allows to see it quite easily :
> https://www.redhat.com/archives/rhelv5-list/2009-February/msg00166.html
> 
>  * I run the script on my Workstation, I have an FTP server enabled
>  * I download a DVD ISO from a remote workstation : The values match
>  * I start ping floods from remote workstations : The values reported
>    by /proc are much higher than the ones reported by tcpdump. I used
>    "ping -s 500 -f myworkstation" from two remote workstations
> 
> If there's anything flawed in my debugging, I'd love to have someone
> point it out to me. TIA to anyone willing to have a look.
> 
> Matthias
> 

There may well be a bug in the kernel you're using, but you'd likely 
have more luck reporting a bug to Red Hat - the RHEL5 kernel is quite 
old and heavily patched and not many LKML people will likely be familiar 
with what RH may have done to it..
