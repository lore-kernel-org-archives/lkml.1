Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbYCLW2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbYCLW2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYCLW2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:28:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbYCLW2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:28:40 -0400
Message-ID: <47D85916.5080203@redhat.com>
Date: Wed, 12 Mar 2008 18:28:38 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: /proc/loadavg: total number of processes is wrong?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# cat /proc/loadavg ; ps ax | wc -l
0.00 0.00 0.00 1/192 3683
121

/proc/loadavg says 192 processes, but ps only sees 121.
