Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab0BNQzk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 11:55:40 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:49586 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab0BNQzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 11:55:35 -0500
From: James Cloos <cloos@jhcloos.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net
Subject: Re: [Regression] Filesystem I/O is CPU-bound in rc7 and rc8
In-Reply-To: <m3pr48bjfg.fsf@lugabout.jhcloos.org> (James Cloos's message of
	"Sat, 13 Feb 2010 22:11:07 -0500")
References: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.90 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Sun, 14 Feb 2010 11:40:10 -0500
Message-ID: <m3eiknbwjh.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:30:100214:linux-kernel@vger.kernel.org::8ZPfIzJbCYzOXbr8:00000000000000000000000000000000sxUKb
X-Hashcash: 1:30:100214:linux-fsdevel@vger.kernel.org::3Rg7iyI7CcSOicDN:0000000000000000000000000000000UUjwy
X-Hashcash: 1:30:100214:linux-ext4@vger.kernel.org::vAO/cGwY8Wa34Oa/:00000000000000000000000000000000009HNEh
X-Hashcash: 1:30:100214:linux-btrfs@vger.kernel.org::eZtAfN9sw7gedw3X:000000000000000000000000000000000CCKzt
X-Hashcash: 1:30:100214:jfs-discussion@lists.sourceforge.net::nRMUahRKFvUd4BJu:000000000000000000000000/M44N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to say:

# CONFIG_SMP is not set
CONFIG_TREE_PREEMPT_RCU=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_PREEMPT_TRACER is not set

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
