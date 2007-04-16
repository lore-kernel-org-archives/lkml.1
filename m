Return-Path: <linux-kernel-owner+w=401wt.eu-S1030907AbXDPT0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030907AbXDPT0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 15:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030901AbXDPT0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 15:26:20 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:55856 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030907AbXDPT0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 15:26:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Q6V6QVu1R5kvBhZoF17IHr6rPGocXQDTHBEEcgvv/82vv+ScVf4RiXZVDO334HTHif/IvwG7qNM0MgzjY24rJCQvJ6HRXxIXOi430he+vwcPjvqP6rivjRN+mV5d/HV6xpwQcdUV4yBrX5JlCcl/PQYx+jp03yLAGsV7BZOIXJY=
Message-ID: <75b66ecd0704161226t40fdb322xfc174dbf3d097bb0@mail.gmail.com>
Date: Mon, 16 Apr 2007 15:26:17 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Bernd Eckenfels" <ecki@lina.inka.de>
Subject: Re: ZFS with Linux: An Open Plea
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <E1HdWld-0003oC-00@calista.eckenfels.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4623BE2E.2020800@s5r6.in-berlin.de>
	 <E1HdWld-0003oC-00@calista.eckenfels.net>
X-Google-Sender-Auth: 9ffd1d5081cc4fd2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/07, Bernd Eckenfels <ecki@lina.inka.de> wrote:
> In article <4623BE2E.2020800@s5r6.in-berlin.de> you wrote:
> > I meant that the central requirement on the design and implementation of
> > audio subsystems is an (ideally guaranteed) bounded maximum of
> > latencies; and that's exactly the major point where I heard that there
> > are problems with ALSA driver components in userspace.  You were talking
> > about throughput of storage systems, for which latencies of the software
> > part of the stack do not play such a central role.  Therefore your
> > comparison appeared off the mark to me.
>
> Unfortunatelle Latency is critical for a number of critical applications
> like databases or file based transaction systems (mail, news) - mainly the
> users of fsync().

Whether you mix audio in userspace or kernel does not impact latency -
you still need to schedule the application playing audio every N
milliseconds or there will be dropouts.  I don't see where audio
mixing issue has any relevance to this thread.

Lee
