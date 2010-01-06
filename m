Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417Ab0AFHtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0AFHtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698Ab0AFHts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:49:48 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:28836 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0AFHts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:49:48 -0500
Message-ID: <4B443E78.7040704@oracle.com>
Date: Wed, 06 Jan 2010 15:40:40 +0800
From: Wenji Huang <wenji.huang@oracle.com>
Reply-To: wenji.huang@oracle.com
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: tracing: Multi definition of TRACE_INCLUDE_FILE
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B444090.00CA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are multi definition of TRACE_INCLUDE_FILE on
include/trace/events/{syscalls, kvm}.h
It will result in compilation error when some
out-of-tree tools like Systemtap processes kernel
tracepoints in a way to put header files into module.

Regards,
Wenji
