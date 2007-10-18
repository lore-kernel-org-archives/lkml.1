Return-Path: <linux-kernel-owner+w=401wt.eu-S1764923AbXJRPlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764923AbXJRPlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbXJRPlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:41:44 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:9508 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbXJRPln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:41:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W21HThumWj9kKdOCB3ZM+SSL0d3UyBbNd/YdRsPeqcKAxJ5nCxONMeJ3LQysdnLLxLoeixpboLUdjCOCbh9h86An/4RlvtZqLDIKlkilOAwBhuFX19+Qf50T2dnX5njpgOObBbDC7ecB+4xoBoUp9OclANi1wd/oN23WGIPSeO8=
Message-ID: <c565abbb0710180841k69045ef6p4373903b9bd1dc7e@mail.gmail.com>
Date: Thu, 18 Oct 2007 16:41:41 +0100
From: "Matthew Faulkner" <matthew.faulkner@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFD] iptables: mangle table obsoletes filter table
In-Reply-To: <200710120814.23903.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710120814.23903.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all

I'm using netperf to perform TCP throughput tests via the localhost
interface. This is being done on a SMP machine. I'm forcing the
netperf server and client to run on the same core. However, for any
packet sizes below 523 the throughput is much lower compared to the
throughput when the packet sizes are greater than 524.

Recv   Send    Send                          Utilization       Service Demand
Socket Socket  Message  Elapsed              Send     Recv     Send    Recv
Size   Size    Size     Time     Throughput  local    remote   local   remote
bytes  bytes   bytes    secs.    MBytes  /s  % S      % S      us/KB   us/KB
 65536  65536    523    30.01        81.49   50.00    50.00    11.984  11.984
 65536  65536    524    30.01       460.61   49.99    49.99    2.120   2.120

The chances are i'm being stupid and there is an obvious reason for
this, but when i put  the server and client on different cores i don't
see this effect.

Any help explaining this will be greatly appreciated.
