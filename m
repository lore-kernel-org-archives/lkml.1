Return-Path: <linux-kernel-owner+w=401wt.eu-S933013AbXJRPmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013AbXJRPmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756952AbXJRPma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:42:30 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:10437 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbXJRPm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:42:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Vu488b38GQcsXsXijb7+7Vx8hsU7fVKWkBtS6uwzR9wIEo8pSi1jlc59Iyg0SowfJiU0j5POsCR/hWO2/xnUK+2N5cyaEwTIuK9Fwa6Q8ar6KTXi5TxBnDSPynE6M/jROnal0As4C+q1oRQ3zvgoZiY68uur1NJCn7M3oXx5cK0=
Message-ID: <c565abbb0710180842u74894da3q490710c5a4571b6d@mail.gmail.com>
Date: Thu, 18 Oct 2007 16:42:24 +0100
From: "Matthew Faulkner" <matthew.faulkner@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Network Throughput Problem...
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
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
