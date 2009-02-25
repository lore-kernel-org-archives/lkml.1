Return-Path: <linux-kernel-owner+w=401wt.eu-S1763427AbZBYW0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763427AbZBYW0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763357AbZBYWZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:25:46 -0500
Received: from movementarian.org ([79.99.65.163]:38340 "EHLO movementarian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763352AbZBYWZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:25:45 -0500
Date: Wed, 25 Feb 2009 17:25:43 -0500
From: wli@movementarian.org
To: linux-kernel@vger.kernel.org
Subject: latencytop traces
Message-ID: <20090225222543.GC5757@movementarian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran into a nasty one.
Here it is.


-- wli

   LatencyTOP version 0.4       (C) 2008 Intel Corporation

Cause                                                Maximum     Percentage
xlog_state_get_iclog_space xlog_write xfs_log_writ1011.4 msec          8.4 %
sync_page __lock_page find_lock_page filemap_fault740.3 msec         30.6 %
down xfs_buf_lock xfs_getsb xfs_trans_getsb xfs_tr676.8 msec          8.8 %
xlog_state_get_iclog_space xlog_write xfs_log_writ527.5 msec          2.6 %
down xfs_buf_lock _xfs_buf_find xfs_buf_get_flags 326.0 msec          0.7 %
xlog_state_get_iclog_space xlog_write xfs_log_writ158.6 msec          0.3 %
xlog_state_get_iclog_space xlog_write xfs_log_writ 70.0 msec          0.2 %
down xfs_buf_lock xfs_getsb xfs_trans_getsb xfs_tr 60.4 msec          0.2 %
Scheduler: waiting for cpu_create xfs_vn_mknod xfs 57.2 msec         18.2 %


Process git (26894)                        Total: 1212.9 msec                   
sync_page __lock_page find_lock_page filemap_fault 57.7 msec         40.0 %lt do
Scheduler: waiting for cpu                         57.2 msec         60.0 %






 zsh  zsh  gnome-volume-co  gconfd-2  smplayer  zsh  evince  pdflush  view  git 

   LatencyTOP version 0.4       (C) 2008 Intel Corporation

Cause                                                Maximum     Percentage
sync_page __lock_page find_lock_page filemap_fault1228.0 msec          5.3 %
sync_page sync_page_killable __lock_page_killable 1200.0 msec         36.5 %
xlog_state_get_iclog_space xlog_write xfs_log_writ172.6 msec          3.8 %
xfs_ilock xfs_iomap __xfs_get_blocks xfs_get_block117.4 msec          0.3 %
do_fork sys_vfork syscall_call generic_file_buffer 43.5 msec          0.1 %
Scheduler: waiting for cpuwrite                    40.0 msec         16.7 %
xfs_buf_iowait _xfs_buf_read xfs_buf_read_flags xf 37.0 msec          2.2 %
down xfs_buf_lock _xfs_buf_find xfs_buf_get_flags  21.4 msec          0.1 %
xfs_buf_iowait _xfs_buf_read xfs_buf_read_flags xf 15.8 msec          0.0 %


Process make (4903)                        Total: 1711.2 msec                   
sync_page __lock_page find_lock_page filemap_fault968.3 msec         56.6 %lt do
sync_page sync_page_killable __lock_page_killable 170.3 msec         17.9 %_read
Scheduler: waiting for cpu_read vfs_read sys_read  31.8 msec         21.8 %
xfs_buf_iowait _xfs_buf_read xfs_buf_read_flags xf 15.1 msec          3.6 %_to_b
pipe_wait pipe_read do_sync_read vfs_read sys_read  0.4 msec          0.0 %th_wa
lk


 vmstat  python  zsh  top  zsh  zsh  gnome-volume-co  gconfd-2  smplayer  make 

