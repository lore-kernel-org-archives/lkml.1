Return-Path: <linux-kernel-owner+w=401wt.eu-S1760732AbXFAMCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732AbXFAMCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 08:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758581AbXFAMCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 08:02:09 -0400
Received: from pool-151-205-99-173.ny325.east.verizon.net ([151.205.99.173]:41543
	"HELO gatworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758510AbXFAMCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 08:02:08 -0400
Message-ID: <46600A85.1040905@gatworks.com>
Date: Fri, 01 Jun 2007 08:01:09 -0400
From: Uncle George <netbeans@gatworks.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: davids@webmaster.com
CC: linux-kernel@vger.kernel.org
Subject: Re: SELECT() returns 1 But FIONREAD says (Input/output error)
References: <MDEHLPKNGKAHNMBLJOLKCENHEDAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKCENHEDAC.davids@webmaster.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:

>> In this case what, will reset the "something interesting has happened"
>> report from the SELECT call? Will it ever be reset in this case?
> 
> Nope. An errored connection is always ready for read/write -- there is
> nothing to wait for as far as the kernel is concerned. Your code keeps
> asking the kernel if something interesting has happened, the kernel keeps
> telling it yes, and it refuses to do anything about it.

Actually its somewhat of a misreading.
The first sentence of the man pages for select suggests that something 
interesting has happened inbetween select()'s.

Later on it states "more precisely, to see if a read will not block", 
which is still different from "if characters become available for reading".

The "precisely" fits my issue, and not the others.
