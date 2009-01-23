Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbZAWWag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbZAWWag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 17:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366AbZAWWa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 17:30:27 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:34638 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297AbZAWWa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 17:30:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=ZvcOE4jz5CEdm+ioqKJFZsu4IiXFODU07JlDOv95aJLaL3h6JNF/x6KOai42n1CV8H
         hHGN6qp8Lr8MdZ1G41+eVXy3m7WnCGxZgD8rkzSz6nOCqq532uMT0OuTSevhJFU959pt
         XyU+ickEAUOsxjQxKzlzszlXtjWD3hi5UlEIc=
Message-ID: <497A44FE.2040905@gmail.com>
Date: Fri, 23 Jan 2009 14:30:22 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: cat /proc/cpuinfo shows full throttle
References: <49798D8B.5050503@gmail.com> <20090123193601.GB1295@redhat.com>
In-Reply-To: <20090123193601.GB1295@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Fri, Jan 23, 2009 at 01:27:39AM -0800, Justin P. Mattock wrote:
>
>  > I'm confused here  when doing a cat /proc/cpuinfo
>  > with an idle system, I see cpu MHz at 2167.000;
>  > should be at 1000.00 (when settled down);
>  >  ..
>  > 
>  > In any case the system is idle and quiet.
>  > it just says full throttle when it should say
>  > nice and quiet.
>  
> is acpi-cpufreq loaded ? and cpufreq-ondemand ?
> (Also make sure the relevant sysfs knobs are set to use ondemand)
>
> If no: Make them so!
> If yes: boot with cpufreq.debug=7 and send the dmesg
>  to cpufreq@vger.kernel.org
>
> Thanks,
>
> 	Dave
>
>   
I've managed to have cat /proc/cpuinfo
read correctly. somewhere somehow
when compiling xserver I Installed
some package that messed up libpowersaved11
and liblazy1. reinstalling those packages as well
as the other powersaved packages seems to have resolved this
issue for me.(as well as haveing  cpufreq running correctly);

I just can't remember what might the package be that
caused this to go crazy.(oh-well);
as long as the fans aren't screaming/or stuck I'm happy...

regards;

Justin P. Mattock
