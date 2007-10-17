Return-Path: <linux-kernel-owner+w=401wt.eu-S934481AbXJQPag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934481AbXJQPag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbXJQPaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:30:14 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41972 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761490AbXJQPaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:30:07 -0400
Subject: 2.6.23-git11 compile issues
From: Badari Pulavarty <pbadari@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 17 Oct 2007 08:33:18 -0700
Message-Id: <1192635199.14504.2.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Known issue ?


Thanks,
Badari

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CC      arch/x86/kernel/asm-offsets.s
In file included from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/crypto.h:20:24: error: asm/atomic.h: No such file or directory
In file included from include/linux/types.h:14,
                 from include/linux/prefetch.h:13,
                 from include/linux/list.h:8,
                 from include/linux/module.h:9,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/posix_types.h:47:29: error: asm/posix_types.h: No such file or directory
In file included from include/linux/prefetch.h:13,
                 from include/linux/list.h:8,
                 from include/linux/module.h:9,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/types.h:15:23: error: asm/types.h: No such file or directory
In file included from include/linux/prefetch.h:13,
                 from include/linux/list.h:8,
                 from include/linux/module.h:9,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/types.h:19: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘__kernel_dev_t’
include/linux/types.h:22: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘dev_t’
include/linux/types.h:23: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘ino_t’
include/linux/types.h:24: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘mode_t’
include/linux/types.h:25: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘nlink_t’
include/linux/types.h:26: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘off_t’
include/linux/types.h:27: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘pid_t’
include/linux/types.h:28: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘daddr_t’
include/linux/types.h:30: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘suseconds_t’
include/linux/types.h:31: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘timer_t’
include/linux/types.h:32: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘clockid_t’
include/linux/types.h:38: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘uid_t’
include/linux/types.h:39: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘gid_t’
include/linux/types.h:40: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘uid16_t’
include/linux/types.h:41: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘gid16_t’
include/linux/types.h:45: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘old_uid_t’
include/linux/types.h:46: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘old_gid_t’
include/linux/types.h:58: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘loff_t’
include/linux/types.h:67: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘size_t’
include/linux/types.h:72: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘ssize_t’
include/linux/types.h:77: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘ptrdiff_t’
include/linux/types.h:82: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘time_t’
include/linux/types.h:87: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘clock_t’
include/linux/types.h:92: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘caddr_t’
include/linux/types.h:110: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘u_int8_t’
include/linux/types.h:111: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘int8_t’
include/linux/types.h:112: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘u_int16_t’
include/linux/types.h:113: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘int16_t’
include/linux/types.h:114: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘u_int32_t’
include/linux/types.h:115: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘int32_t’
include/linux/types.h:119: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘uint8_t’
include/linux/types.h:120: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘uint16_t’
include/linux/types.h:121: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘uint32_t’
include/linux/types.h:124: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘uint64_t’
include/linux/types.h:125: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘u_int64_t’
include/linux/types.h:126: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘int64_t’
include/linux/types.h:181: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘__le16’
include/linux/types.h:182: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘__be16’
include/linux/types.h:183: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘__le32’
include/linux/types.h:184: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘__be32’
include/linux/types.h:186: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘__le64’
include/linux/types.h:187: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘__be64’
include/linux/types.h:189: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘__sum16’
include/linux/types.h:190: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘__wsum’
include/linux/types.h:196: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘resource_size_t’
include/linux/types.h:204: error: expected specifier-qualifier-list before ‘__kernel_daddr_t’
In file included from include/linux/list.h:8,
                 from include/linux/module.h:9,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/prefetch.h:14:27: error: asm/processor.h: No such file or directory
include/linux/prefetch.h:15:23: error: asm/cache.h: No such file or directory
In file included from include/linux/list.h:8,
                 from include/linux/module.h:9,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/prefetch.h:58: error: expected declaration specifiers or ‘...’ before ‘size_t’
In file included from include/linux/module.h:9,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/list.h:9:24: error: asm/system.h: No such file or directory
In file included from include/linux/module.h:9,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/list.h: In function ‘__list_add_rcu’:
include/linux/list.h:100: error: implicit declaration of function ‘smp_wmb’
In file included from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/stat.h:6:22: error: asm/stat.h: No such file or directory
In file included from include/linux/kernel.h:11,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:7,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/linkage.h:4:25: error: asm/linkage.h: No such file or directory
In file included from include/linux/kernel.h:15,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:7,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/bitops.h:9:24: error: asm/bitops.h: No such file or directory
In file included from include/linux/kernel.h:15,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:7,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/bitops.h: In function ‘get_bitmask_order’:
include/linux/bitops.h:21: error: implicit declaration of function ‘fls’
include/linux/bitops.h: In function ‘hweight_long’:
include/linux/bitops.h:37: error: implicit declaration of function ‘hweight32’
include/linux/bitops.h:37: error: implicit declaration of function ‘hweight64’
include/linux/bitops.h: At top level:
include/linux/bitops.h:45: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘rol32’
include/linux/bitops.h:55: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘ror32’
include/linux/bitops.h: In function ‘fls_long’:
include/linux/bitops.h:64: error: implicit declaration of function ‘fls64’
In file included from include/linux/kernel.h:16,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:7,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/log2.h: At top level:
include/linux/log2.h:32: error: expected ‘)’ before ‘n’
include/linux/log2.h:40: error: expected ‘)’ before ‘n’
In file included from include/linux/cache.h:4,
                 from include/linux/time.h:7,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/kernel.h:17:27: error: asm/byteorder.h: No such file or directory
include/linux/kernel.h:18:21: error: asm/bug.h: No such file or directory
In file included from include/linux/cache.h:4,
                 from include/linux/time.h:7,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/kernel.h:141: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/kernel.h:142: error: format string argument not a string type
include/linux/kernel.h:142: warning: conflicting types for built-in function ‘snprintf’
include/linux/kernel.h:143: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/kernel.h:144: error: format string argument not a string type
include/linux/kernel.h:144: warning: conflicting types for built-in function ‘vsnprintf’
include/linux/kernel.h:145: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/kernel.h:146: error: format string argument not a string type
include/linux/kernel.h:147: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/kernel.h:148: error: format string argument not a string type
include/linux/kernel.h:238: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/kernel.h:240: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/kernel.h:243: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/kernel.h:245: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/kernel.h:294:2: error: #error "Please fix asm/byteorder.h"
In file included from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:49,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/thread_info.h:21:29: error: asm/thread_info.h: No such file or directory
In file included from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:49,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/thread_info.h:30: warning: ‘struct thread_info’ declared inside parameter list
include/linux/thread_info.h:30: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/thread_info.h: In function ‘set_ti_thread_flag’:
include/linux/thread_info.h:32: error: implicit declaration of function ‘set_bit’
include/linux/thread_info.h:32: error: dereferencing pointer to incomplete type
include/linux/thread_info.h: At top level:
include/linux/thread_info.h:35: warning: ‘struct thread_info’ declared inside parameter list
include/linux/thread_info.h: In function ‘clear_ti_thread_flag’:
include/linux/thread_info.h:37: error: implicit declaration of function ‘clear_bit’
include/linux/thread_info.h:37: error: dereferencing pointer to incomplete type
include/linux/thread_info.h: At top level:
include/linux/thread_info.h:40: warning: ‘struct thread_info’ declared inside parameter list
include/linux/thread_info.h: In function ‘test_and_set_ti_thread_flag’:
include/linux/thread_info.h:42: error: implicit declaration of function ‘test_and_set_bit’
include/linux/thread_info.h:42: error: dereferencing pointer to incomplete type
include/linux/thread_info.h: At top level:
include/linux/thread_info.h:45: warning: ‘struct thread_info’ declared inside parameter list
include/linux/thread_info.h: In function ‘test_and_clear_ti_thread_flag’:
include/linux/thread_info.h:47: error: implicit declaration of function ‘test_and_clear_bit’
include/linux/thread_info.h:47: error: dereferencing pointer to incomplete type
include/linux/thread_info.h: At top level:
include/linux/thread_info.h:50: warning: ‘struct thread_info’ declared inside parameter list
include/linux/thread_info.h: In function ‘test_ti_thread_flag’:
include/linux/thread_info.h:52: error: implicit declaration of function ‘test_bit’
include/linux/thread_info.h:52: error: dereferencing pointer to incomplete type
In file included from include/linux/spinlock.h:79,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/spinlock_types.h:13:33: error: asm/spinlock_types.h: No such file or directory
In file included from include/linux/spinlock.h:79,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/spinlock_types.h: At top level:
include/linux/spinlock_types.h:21: error: expected specifier-qualifier-list before ‘raw_spinlock_t’
include/linux/spinlock_types.h:37: error: expected specifier-qualifier-list before ‘raw_rwlock_t’
In file included from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/spinlock.h:81: error: expected ‘)’ before ‘*’ token
In file included from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/spinlock.h:87:27: error: asm/spinlock.h: No such file or directory
In file included from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/spinlock.h: In function ‘double_spin_unlock’:
include/linux/spinlock.h:321: error: implicit declaration of function ‘__raw_spin_unlock’
include/linux/spinlock.h:321: error: ‘spinlock_t’ has no member named ‘raw_lock’
include/linux/spinlock.h:322: error: ‘spinlock_t’ has no member named ‘raw_lock’
include/linux/spinlock.h:324: error: ‘spinlock_t’ has no member named ‘raw_lock’
include/linux/spinlock.h:325: error: ‘spinlock_t’ has no member named ‘raw_lock’
include/linux/spinlock.h: At top level:
include/linux/spinlock.h:339: error: expected ‘)’ before ‘*’ token
In file included from include/linux/time.h:8,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/seqlock.h: In function ‘write_sequnlock’:
include/linux/seqlock.h:71: error: ‘spinlock_t’ has no member named ‘raw_lock’
include/linux/seqlock.h: In function ‘read_seqbegin’:
include/linux/seqlock.h:89: error: implicit declaration of function ‘smp_rmb’
In file included from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/time.h: At top level:
include/linux/time.h:14: error: expected specifier-qualifier-list before ‘time_t’
include/linux/time.h:20: error: expected specifier-qualifier-list before ‘time_t’
include/linux/time.h: In function ‘timespec_equal’:
include/linux/time.h:43: error: ‘const struct timespec’ has no member named ‘tv_sec’
include/linux/time.h:43: error: ‘const struct timespec’ has no member named ‘tv_sec’
include/linux/time.h:43: error: ‘const struct timespec’ has no member named ‘tv_nsec’
include/linux/time.h:43: error: ‘const struct timespec’ has no member named ‘tv_nsec’
include/linux/time.h: In function ‘timespec_compare’:
include/linux/time.h:53: error: ‘const struct timespec’ has no member named ‘tv_sec’
include/linux/time.h:53: error: ‘const struct timespec’ has no member named ‘tv_sec’
include/linux/time.h:55: error: ‘const struct timespec’ has no member named ‘tv_sec’
include/linux/time.h:55: error: ‘const struct timespec’ has no member named ‘tv_sec’
include/linux/time.h:57: error: ‘const struct timespec’ has no member named ‘tv_nsec’
include/linux/time.h:57: error: ‘const struct timespec’ has no member named ‘tv_nsec’
include/linux/time.h: In function ‘timeval_compare’:
include/linux/time.h:62: error: ‘const struct timeval’ has no member named ‘tv_sec’
include/linux/time.h:62: error: ‘const struct timeval’ has no member named ‘tv_sec’
include/linux/time.h:64: error: ‘const struct timeval’ has no member named ‘tv_sec’
include/linux/time.h:64: error: ‘const struct timeval’ has no member named ‘tv_sec’
include/linux/time.h:66: error: ‘const struct timeval’ has no member named ‘tv_usec’
include/linux/time.h:66: error: ‘const struct timeval’ has no member named ‘tv_usec’
include/linux/time.h: At top level:
include/linux/time.h:73: error: expected declaration specifiers or ‘...’ before ‘time_t’
include/linux/time.h: In function ‘timespec_sub’:
include/linux/time.h:82: error: ‘struct timespec’ has no member named ‘tv_sec’
include/linux/time.h:82: error: ‘struct timespec’ has no member named ‘tv_sec’
include/linux/time.h:83: error: ‘struct timespec’ has no member named ‘tv_nsec’
include/linux/time.h:83: error: ‘struct timespec’ has no member named ‘tv_nsec’
include/linux/time.h:83: error: too many arguments to function ‘set_normalized_timespec’
include/linux/time.h: At top level:
include/linux/time.h:133: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘timespec_to_ns’
include/linux/time.h:145: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘timeval_to_ns’
include/linux/time.h:157: warning: type defaults to ‘int’ in declaration of ‘s64’
include/linux/time.h:157: error: expected ‘;’, ‘,’ or ‘)’ before ‘nsec’
include/linux/time.h:165: warning: type defaults to ‘int’ in declaration of ‘s64’
include/linux/time.h:165: error: expected ‘;’, ‘,’ or ‘)’ before ‘nsec’
include/linux/time.h:172: error: expected declaration specifiers or ‘...’ before ‘u64’
include/linux/time.h: In function ‘timespec_add_ns’:
include/linux/time.h:174: error: ‘ns’ undeclared (first use in this function)
include/linux/time.h:174: error: (Each undeclared identifier is reported only once
include/linux/time.h:174: error: for each function it appears in.)
include/linux/time.h:174: error: ‘struct timespec’ has no member named ‘tv_nsec’
include/linux/time.h:177: error: ‘struct timespec’ has no member named ‘tv_sec’
include/linux/time.h:179: error: ‘struct timespec’ has no member named ‘tv_nsec’
In file included from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/stat.h: At top level:
include/linux/stat.h:63: error: expected specifier-qualifier-list before ‘u64’
In file included from include/linux/kmod.h:23,
                 from include/linux/module.h:13,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/errno.h:4:23: error: asm/errno.h: No such file or directory
In file included from include/linux/module.h:13,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/kmod.h: In function ‘call_usermodehelper’:
include/linux/kmod.h:74: error: ‘ENOMEM’ undeclared (first use in this function)
include/linux/kmod.h: In function ‘call_usermodehelper_keys’:
include/linux/kmod.h:86: error: ‘ENOMEM’ undeclared (first use in this function)
In file included from include/linux/elf.h:5,
                 from include/linux/module.h:14,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/auxvec.h:4:24: error: asm/auxvec.h: No such file or directory
In file included from include/linux/module.h:14,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/elf.h:7:21: error: asm/elf.h: No such file or directory
In file included from include/linux/module.h:14,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/elf.h: At top level:
include/linux/elf.h:19: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘Elf32_Addr’
include/linux/elf.h:20: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘Elf32_Half’
include/linux/elf.h:21: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘Elf32_Off’
include/linux/elf.h:22: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘Elf32_Sword’
include/linux/elf.h:23: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘Elf32_Word’
include/linux/elf.h:26: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘Elf64_Addr’
include/linux/elf.h:27: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘Elf64_Half’
include/linux/elf.h:28: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘Elf64_SHalf’
include/linux/elf.h:29: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘Elf64_Off’
include/linux/elf.h:30: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘Elf64_Sword’
include/linux/elf.h:31: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘Elf64_Word’
include/linux/elf.h:32: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘Elf64_Xword’
include/linux/elf.h:33: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘Elf64_Sxword’
include/linux/elf.h:127: error: expected specifier-qualifier-list before ‘Elf32_Sword’
include/linux/elf.h:135: error: expected specifier-qualifier-list before ‘Elf64_Sxword’
include/linux/elf.h:150: error: expected specifier-qualifier-list before ‘Elf32_Addr’
include/linux/elf.h:155: error: expected specifier-qualifier-list before ‘Elf64_Addr’
include/linux/elf.h:160: error: expected specifier-qualifier-list before ‘Elf32_Addr’
include/linux/elf.h:166: error: expected specifier-qualifier-list before ‘Elf64_Addr’
include/linux/elf.h:172: error: expected specifier-qualifier-list before ‘Elf32_Word’
include/linux/elf.h:181: error: expected specifier-qualifier-list before ‘Elf64_Word’
include/linux/elf.h:194: error: expected specifier-qualifier-list before ‘Elf32_Half’
include/linux/elf.h:211: error: expected specifier-qualifier-list before ‘Elf64_Half’
include/linux/elf.h:233: error: expected specifier-qualifier-list before ‘Elf32_Word’
include/linux/elf.h:244: error: expected specifier-qualifier-list before ‘Elf64_Word’
include/linux/elf.h:289: error: expected specifier-qualifier-list before ‘Elf32_Word’
include/linux/elf.h:302: error: expected specifier-qualifier-list before ‘Elf64_Word’
include/linux/elf.h:362: error: expected specifier-qualifier-list before ‘Elf32_Word’
include/linux/elf.h:369: error: expected specifier-qualifier-list before ‘Elf64_Word’
include/linux/elf.h:374:5: warning: "ELF_CLASS" is not defined
include/linux/elf.h:396: error: expected declaration specifiers or ‘...’ before ‘loff_t’
In file included from include/linux/kobject.h:24,
                 from include/linux/module.h:16,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/sysfs.h:30: error: expected specifier-qualifier-list before ‘mode_t’
include/linux/sysfs.h:64: error: expected specifier-qualifier-list before ‘size_t’
include/linux/sysfs.h:75: error: expected specifier-qualifier-list before ‘ssize_t’
include/linux/sysfs.h:93: error: expected declaration specifiers or ‘...’ before ‘mode_t’
In file included from include/linux/kobject.h:27,
                 from include/linux/module.h:16,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/kref.h:24: error: expected specifier-qualifier-list before ‘atomic_t’
In file included from include/linux/kobject.h:29,
                 from include/linux/module.h:16,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/wait.h:26:25: error: asm/current.h: No such file or directory
In file included from include/linux/module.h:16,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/kobject.h:41: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘uevent_seqnum’
include/linux/kobject.h:228: error: expected specifier-qualifier-list before ‘ssize_t’
include/linux/kobject.h:243: error: expected declaration specifiers or ‘...’ before ‘size_t’
In file included from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/module.h:18:23: error: asm/local.h: No such file or directory
include/linux/module.h:20:24: error: asm/module.h: No such file or directory
In file included from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/module.h:48: error: expected specifier-qualifier-list before ‘ssize_t’
include/linux/module.h:221: error: expected specifier-qualifier-list before ‘local_t’
include/linux/module.h:222: error: requested alignment is not a constant
include/linux/module.h:313: error: field ‘arch’ has incomplete type
include/linux/module.h:329: error: ‘NR_CPUS’ undeclared here (not in a function)
include/linux/module.h:343: error: expected specifier-qualifier-list before ‘Elf_Sym’
include/linux/module.h: In function ‘__module_get’:
include/linux/module.h:398: error: implicit declaration of function ‘BUG_ON’
include/linux/module.h:399: error: implicit declaration of function ‘local_inc’
include/linux/module.h:399: error: implicit declaration of function ‘get_cpu’
include/linux/module.h:400: error: implicit declaration of function ‘put_cpu’
In file included from include/linux/bitmap.h:8,
                 from include/linux/nodemask.h:85,
                 from include/linux/mmzone.h:15,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/string.h:21:24: error: asm/string.h: No such file or directory
In file included from include/linux/bitmap.h:8,
                 from include/linux/nodemask.h:85,
                 from include/linux/mmzone.h:15,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/string.h: At top level:
include/linux/string.h:27: error: expected declaration specifiers or ‘...’ before ‘__kernel_size_t’
include/linux/string.h:27: warning: conflicting types for built-in function ‘strncpy’
include/linux/string.h:30: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘strlcpy’
include/linux/string.h:36: error: expected declaration specifiers or ‘...’ before ‘__kernel_size_t’
include/linux/string.h:36: warning: conflicting types for built-in function ‘strncat’
include/linux/string.h:39: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘strlcat’
include/linux/string.h:45: error: expected declaration specifiers or ‘...’ before ‘__kernel_size_t’
include/linux/string.h:45: warning: conflicting types for built-in function ‘strncmp’
include/linux/string.h:48: error: expected declaration specifiers or ‘...’ before ‘__kernel_size_t’
include/linux/string.h:54: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/string.h:54: warning: conflicting types for built-in function ‘strncasecmp’
include/linux/string.h:60: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/string.h:70: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘strlen’
include/linux/string.h:73: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘strnlen’
include/linux/string.h:82: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘strspn’
include/linux/string.h:85: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘strcspn’
include/linux/string.h:89: error: expected declaration specifiers or ‘...’ before ‘__kernel_size_t’
include/linux/string.h:89: warning: conflicting types for built-in function ‘memset’
include/linux/string.h:92: error: expected declaration specifiers or ‘...’ before ‘__kernel_size_t’
include/linux/string.h:92: warning: conflicting types for built-in function ‘memcpy’
include/linux/string.h:95: error: expected declaration specifiers or ‘...’ before ‘__kernel_size_t’
include/linux/string.h:95: warning: conflicting types for built-in function ‘memmove’
include/linux/string.h:98: error: expected declaration specifiers or ‘...’ before ‘__kernel_size_t’
include/linux/string.h:101: error: expected declaration specifiers or ‘...’ before ‘__kernel_size_t’
include/linux/string.h:101: warning: conflicting types for built-in function ‘memcmp’
include/linux/string.h:104: error: expected declaration specifiers or ‘...’ before ‘__kernel_size_t’
include/linux/string.h:108: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/string.h:109: error: expected declaration specifiers or ‘...’ before ‘size_t’
In file included from include/linux/nodemask.h:85,
                 from include/linux/mmzone.h:15,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/bitmap.h: In function ‘bitmap_zero’:
include/linux/bitmap.h:134: error: ‘BITS_PER_LONG’ undeclared (first use in this function)
include/linux/bitmap.h:138: error: too many arguments to function ‘memset’
include/linux/bitmap.h: In function ‘bitmap_fill’:
include/linux/bitmap.h:144: error: ‘size_t’ undeclared (first use in this function)
include/linux/bitmap.h:144: error: expected ‘;’ before ‘nlongs’
include/linux/bitmap.h:145: error: ‘nlongs’ undeclared (first use in this function)
include/linux/bitmap.h:147: error: too many arguments to function ‘memset’
include/linux/bitmap.h:149: error: ‘BITS_PER_LONG’ undeclared (first use in this function)
include/linux/bitmap.h: In function ‘bitmap_copy’:
include/linux/bitmap.h:155: error: ‘BITS_PER_LONG’ undeclared (first use in this function)
include/linux/bitmap.h:159: error: too many arguments to function ‘memcpy’
include/linux/bitmap.h: In function ‘bitmap_and’:
include/linux/bitmap.h:166: error: ‘BITS_PER_LONG’ undeclared (first use in this function)
include/linux/bitmap.h: In function ‘bitmap_or’:
include/linux/bitmap.h:175: error: ‘BITS_PER_LONG’ undeclared (first use in this function)
include/linux/bitmap.h: In function ‘bitmap_xor’:
include/linux/bitmap.h:184: error: ‘BITS_PER_LONG’ undeclared (first use in this function)
include/linux/bitmap.h: In function ‘bitmap_andnot’:
include/linux/bitmap.h:193: error: ‘BITS_PER_LONG’ undeclared (first use in this function)
include/linux/bitmap.h: In function ‘bitmap_complement’:
include/linux/bitmap.h:202: error: ‘BITS_PER_LONG’ undeclared (first use in this function)
include/linux/bitmap.h: In function ‘bitmap_equal’:
include/linux/bitmap.h:211: error: ‘BITS_PER_LONG’ undeclared (first use in this function)
include/linux/bitmap.h: In function ‘bitmap_intersects’:
include/linux/bitmap.h:220: error: ‘BITS_PER_LONG’ undeclared (first use in this function)
include/linux/bitmap.h: In function ‘bitmap_subset’:
include/linux/bitmap.h:229: error: ‘BITS_PER_LONG’ undeclared (first use in this function)
include/linux/bitmap.h: In function ‘bitmap_empty’:
include/linux/bitmap.h:237: error: ‘BITS_PER_LONG’ undeclared (first use in this function)
include/linux/bitmap.h: In function ‘bitmap_full’:
include/linux/bitmap.h:245: error: ‘BITS_PER_LONG’ undeclared (first use in this function)
include/linux/bitmap.h: In function ‘bitmap_weight’:
include/linux/bitmap.h:253: error: ‘BITS_PER_LONG’ undeclared (first use in this function)
include/linux/bitmap.h: In function ‘bitmap_shift_right’:
include/linux/bitmap.h:261: error: ‘BITS_PER_LONG’ undeclared (first use in this function)
include/linux/bitmap.h: In function ‘bitmap_shift_left’:
include/linux/bitmap.h:270: error: ‘BITS_PER_LONG’ undeclared (first use in this function)
In file included from include/linux/mmzone.h:15,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/nodemask.h: At top level:
include/linux/nodemask.h:88: error: ‘BITS_PER_LONG’ undeclared here (not in a function)
include/linux/nodemask.h: In function ‘__first_node’:
include/linux/nodemask.h:229: error: implicit declaration of function ‘find_first_bit’
include/linux/nodemask.h: In function ‘__next_node’:
include/linux/nodemask.h:235: error: implicit declaration of function ‘find_next_bit’
include/linux/nodemask.h: In function ‘__first_unset_node’:
include/linux/nodemask.h:253: error: implicit declaration of function ‘find_first_zero_bit’
In file included from include/linux/mmzone.h:15,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/nodemask.h:259:21: warning: "BITS_PER_LONG" is not defined
In file included from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/mmzone.h:18:22: error: asm/page.h: No such file or directory
In file included from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/mmzone.h: At top level:
include/linux/mmzone.h:73: error: ‘L1_CACHE_SHIFT’ undeclared here (not in a function)
include/linux/mmzone.h:73: error: requested alignment is not a constant
include/linux/mmzone.h:117: error: expected specifier-qualifier-list before ‘s8’
include/linux/mmzone.h:123: error: requested alignment is not a constant
include/linux/mmzone.h:268: error: expected specifier-qualifier-list before ‘atomic_t’
include/linux/mmzone.h:344: error: requested alignment is not a constant
In file included from include/linux/notifier.h:13,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:535,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/mutex.h:49: error: expected specifier-qualifier-list before ‘atomic_t’
include/linux/mutex.h: In function ‘mutex_is_locked’:
include/linux/mutex.h:116: error: implicit declaration of function ‘atomic_read’
include/linux/mutex.h:116: error: ‘struct mutex’ has no member named ‘count’
In file included from include/linux/rwsem.h:22,
                 from include/linux/notifier.h:14,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:535,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/rwsem-spinlock.h: At top level:
include/linux/rwsem-spinlock.h:32: error: expected specifier-qualifier-list before ‘__s32’
include/linux/rwsem-spinlock.h: In function ‘rwsem_is_locked’:
include/linux/rwsem-spinlock.h:74: error: ‘struct rw_semaphore’ has no member named ‘activity’
In file included from include/linux/mmzone.h:535,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/memory_hotplug.h: In function ‘pgdat_resize_init’:
include/linux/memory_hotplug.h:29: error: unknown field ‘raw_lock’ specified in initializer
include/linux/memory_hotplug.h:29: error: ‘__RAW_SPIN_LOCK_UNLOCKED’ undeclared (first use in this function)
include/linux/memory_hotplug.h:29: warning: excess elements in struct initializer
include/linux/memory_hotplug.h:29: warning: (near initialization for ‘(anonymous)’)
include/linux/memory_hotplug.h: In function ‘zone_seqlock_init’:
include/linux/memory_hotplug.h:52: error: unknown field ‘raw_lock’ specified in initializer
include/linux/memory_hotplug.h:52: error: ‘__RAW_SPIN_LOCK_UNLOCKED’ undeclared (first use in this function)
include/linux/memory_hotplug.h:52: warning: excess elements in struct initializer
include/linux/memory_hotplug.h:52: warning: (near initialization for ‘(anonymous)’)
include/linux/memory_hotplug.h: At top level:
include/linux/memory_hotplug.h:77: error: expected ‘)’ before ‘start’
include/linux/memory_hotplug.h:174: error: expected declaration specifiers or ‘...’ before ‘u64’
include/linux/memory_hotplug.h:174: error: expected declaration specifiers or ‘...’ before ‘u64’
include/linux/memory_hotplug.h:175: error: expected declaration specifiers or ‘...’ before ‘u64’
include/linux/memory_hotplug.h:175: error: expected declaration specifiers or ‘...’ before ‘u64’
include/linux/memory_hotplug.h:176: error: expected ‘)’ before ‘start’
In file included from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/mmzone.h: In function ‘populated_zone’:
include/linux/mmzone.h:568: error: ‘struct zone’ has no member named ‘present_pages’
include/linux/mmzone.h: In function ‘is_normal’:
include/linux/mmzone.h:616: error: ‘struct zone’ has no member named ‘zone_pgdat’
include/linux/mmzone.h: In function ‘is_dma32’:
include/linux/mmzone.h:622: error: ‘struct zone’ has no member named ‘zone_pgdat’
include/linux/mmzone.h: In function ‘is_dma’:
include/linux/mmzone.h:631: error: ‘struct zone’ has no member named ‘zone_pgdat’
include/linux/mmzone.h: At top level:
include/linux/mmzone.h:641: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/mmzone.h:641: error: expected declaration specifiers or ‘...’ before ‘loff_t’
include/linux/mmzone.h:644: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/mmzone.h:644: error: expected declaration specifiers or ‘...’ before ‘loff_t’
include/linux/mmzone.h:646: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/mmzone.h:646: error: expected declaration specifiers or ‘...’ before ‘loff_t’
include/linux/mmzone.h:648: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/mmzone.h:648: error: expected declaration specifiers or ‘...’ before ‘loff_t’
include/linux/mmzone.h:650: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/mmzone.h:650: error: expected declaration specifiers or ‘...’ before ‘loff_t’
include/linux/mmzone.h:653: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/mmzone.h:653: error: expected declaration specifiers or ‘...’ before ‘loff_t’
In file included from include/linux/topology.h:30,
                 from include/linux/mmzone.h:657,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/cpumask.h:239:16: warning: "BITS_PER_LONG" is not defined
In file included from include/linux/topology.h:33,
                 from include/linux/mmzone.h:657,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/smp.h:19:21: error: asm/smp.h: No such file or directory
In file included from include/linux/mmzone.h:657,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/topology.h:34:26: error: asm/topology.h: No such file or directory
include/linux/topology.h:202:2: error: #error Please define an appropriate SD_NODE_INIT in include/asm/topology.h!!!
In file included from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/mmzone.h:672:24: error: asm/mmzone.h: No such file or directory
include/linux/mmzone.h:704:5: warning: "BITS_PER_LONG" is not defined
include/linux/mmzone.h:711:7: warning: "BITS_PER_LONG" is not defined
include/linux/mmzone.h:719:2: error: #error BITS_PER_LONG not defined
In file included from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/gfp.h: In function ‘allocflags_to_migratetype’:
include/linux/gfp.h:110: error: implicit declaration of function ‘WARN_ON’
include/linux/gfp.h: In function ‘alloc_pages_node’:
include/linux/gfp.h:186: error: implicit declaration of function ‘cpu_to_node’
include/linux/gfp.h:186: error: implicit declaration of function ‘raw_smp_processor_id’
include/linux/gfp.h:189: error: implicit declaration of function ‘NODE_DATA’
include/linux/gfp.h:189: error: invalid type argument of ‘->’
In file included from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/slab.h: At top level:
include/linux/slab.h:54: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/slab.h:54: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/slab.h:94: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/slab.h:96: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘ksize’
In file included from include/linux/slab.h:122,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/slab_def.h:20: error: expected specifier-qualifier-list before ‘size_t’
include/linux/slab_def.h:29: error: expected ‘)’ before ‘size’
include/linux/slab_def.h:31: error: expected ‘)’ before ‘size’
In file included from include/linux/slab_def.h:44,
                 from include/linux/slab.h:122,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/kmalloc_sizes.h:1:6: warning: "PAGE_SIZE" is not defined
include/linux/kmalloc_sizes.h:5:5: warning: "L1_CACHE_BYTES" is not defined
include/linux/kmalloc_sizes.h:9:5: warning: "L1_CACHE_BYTES" is not defined
include/linux/kmalloc_sizes.h:22:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:22:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:25:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:25:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:28:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:28:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:31:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:31:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:34:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:34:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:37:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:37:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:40:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:40:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:43:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:43:5: warning: "PAGE_SHIFT" is not defined
In file included from include/linux/slab.h:122,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/slab_def.h:62: error: expected ‘)’ before ‘size’
include/linux/slab_def.h:65: error: expected ‘)’ before ‘size’
In file included from include/linux/slab_def.h:78,
                 from include/linux/slab.h:122,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/kmalloc_sizes.h:1:6: warning: "PAGE_SIZE" is not defined
include/linux/kmalloc_sizes.h:5:5: warning: "L1_CACHE_BYTES" is not defined
include/linux/kmalloc_sizes.h:9:5: warning: "L1_CACHE_BYTES" is not defined
include/linux/kmalloc_sizes.h:22:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:22:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:25:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:25:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:28:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:28:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:31:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:31:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:34:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:34:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:37:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:37:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:40:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:40:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:43:5: warning: "PAGE_SHIFT" is not defined
include/linux/kmalloc_sizes.h:43:5: warning: "PAGE_SHIFT" is not defined
In file included from include/linux/slab.h:122,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/slab_def.h:99: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘slabinfo_write’
In file included from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/slab.h:176: error: expected ‘)’ before ‘n’
include/linux/slab.h:222: error: expected ‘)’ before ‘gfp_t’
include/linux/slab.h:240: error: expected ‘)’ before ‘gfp_t’
include/linux/slab.h:269: error: expected ‘)’ before ‘size’
In file included from include/linux/crypto.h:26,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/uaccess.h:5:25: error: asm/uaccess.h: No such file or directory
In file included from include/linux/crypto.h:26,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/uaccess.h: In function ‘pagefault_disable’:
include/linux/uaccess.h:18: error: implicit declaration of function ‘current_thread_info’
include/linux/uaccess.h:18: error: invalid type argument of ‘->’
include/linux/uaccess.h: In function ‘pagefault_enable’:
include/linux/uaccess.h:33: error: invalid type argument of ‘->’
include/linux/uaccess.h: In function ‘__copy_from_user_inatomic_nocache’:
include/linux/uaccess.h:46: error: implicit declaration of function ‘__copy_from_user_inatomic’
include/linux/uaccess.h: In function ‘__copy_from_user_nocache’:
include/linux/uaccess.h:52: error: implicit declaration of function ‘__copy_from_user’
In file included from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/crypto.h: At top level:
include/linux/crypto.h:109: error: expected specifier-qualifier-list before ‘u32’
include/linux/crypto.h:142: error: expected specifier-qualifier-list before ‘u8’
include/linux/crypto.h:154: error: expected specifier-qualifier-list before ‘u32’
include/linux/crypto.h:159: error: expected declaration specifiers or ‘...’ before ‘u8’
include/linux/crypto.h:159: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:159: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:160: error: expected ‘;’ before ‘unsigned’
include/linux/crypto.h:167: error: expected specifier-qualifier-list before ‘u32’
include/linux/crypto.h:175: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:175: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:177: error: expected ‘;’ before ‘int’
include/linux/crypto.h:186: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:186: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:188: error: expected ‘;’ before ‘int’
include/linux/crypto.h:196: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:196: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:198: error: expected ‘;’ before ‘int’
include/linux/crypto.h:213: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:213: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:215: error: expected ‘;’ before ‘void’
include/linux/crypto.h:222: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:222: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:224: error: expected ‘;’ before ‘void’
include/linux/crypto.h:233: error: expected declaration specifiers or ‘...’ before ‘u8’
include/linux/crypto.h:235: error: expected declaration specifiers or ‘...’ before ‘u8’
include/linux/crypto.h:236: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:236: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:239: error: expected ‘;’ before ‘unsigned’
include/linux/crypto.h:243: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:243: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:245: error: expected ‘;’ before ‘int’
include/linux/crypto.h:261: error: expected specifier-qualifier-list before ‘u32’
include/linux/crypto.h:301: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h:301: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h:316: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:316: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:318: error: expected ‘;’ before ‘int’
include/linux/crypto.h:325: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:325: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:327: error: expected ‘;’ before ‘int’
include/linux/crypto.h:336: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:336: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:338: error: expected ‘;’ before ‘int’
include/linux/crypto.h:346: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:346: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:347: error: expected ‘;’ before ‘void’
include/linux/crypto.h:355: error: expected declaration specifiers or ‘...’ before ‘u8’
include/linux/crypto.h:357: error: expected declaration specifiers or ‘...’ before ‘u8’
include/linux/crypto.h:358: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:358: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:360: error: expected ‘;’ before ‘unsigned’
include/linux/crypto.h:365: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:365: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:367: error: expected ‘;’ before ‘int’
include/linux/crypto.h:381: error: expected specifier-qualifier-list before ‘u32’
include/linux/crypto.h:439: error: expected specifier-qualifier-list before ‘u32’
include/linux/crypto.h:444: error: expected specifier-qualifier-list before ‘u32’
include/linux/crypto.h:451: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h:452: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h:452: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_tfm_alg_name’:
include/linux/crypto.h:460: error: ‘struct crypto_tfm’ has no member named ‘__crt_alg’
include/linux/crypto.h: In function ‘crypto_tfm_alg_driver_name’:
include/linux/crypto.h:465: error: ‘struct crypto_tfm’ has no member named ‘__crt_alg’
include/linux/crypto.h: In function ‘crypto_tfm_alg_priority’:
include/linux/crypto.h:470: error: ‘struct crypto_tfm’ has no member named ‘__crt_alg’
include/linux/crypto.h: In function ‘crypto_tfm_alg_modname’:
include/linux/crypto.h:475: error: ‘struct crypto_tfm’ has no member named ‘__crt_alg’
include/linux/crypto.h: At top level:
include/linux/crypto.h:478: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘crypto_tfm_alg_type’
include/linux/crypto.h: In function ‘crypto_tfm_alg_blocksize’:
include/linux/crypto.h:485: error: ‘struct crypto_tfm’ has no member named ‘__crt_alg’
include/linux/crypto.h: In function ‘crypto_tfm_alg_alignmask’:
include/linux/crypto.h:490: error: ‘struct crypto_tfm’ has no member named ‘__crt_alg’
include/linux/crypto.h: At top level:
include/linux/crypto.h:493: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘crypto_tfm_get_flags’
include/linux/crypto.h:498: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_tfm_set_flags’:
include/linux/crypto.h:500: error: ‘struct crypto_tfm’ has no member named ‘crt_flags’
include/linux/crypto.h:500: error: ‘flags’ undeclared (first use in this function)
include/linux/crypto.h: At top level:
include/linux/crypto.h:503: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_tfm_clear_flags’:
include/linux/crypto.h:505: error: ‘struct crypto_tfm’ has no member named ‘crt_flags’
include/linux/crypto.h:505: error: ‘flags’ undeclared (first use in this function)
include/linux/crypto.h: In function ‘crypto_tfm_ctx’:
include/linux/crypto.h:510: error: ‘struct crypto_tfm’ has no member named ‘__crt_ctx’
include/linux/crypto.h: In function ‘crypto_tfm_ctx_alignment’:
include/linux/crypto.h:516: error: ‘struct crypto_tfm’ has no member named ‘__crt_ctx’
include/linux/crypto.h: At top level:
include/linux/crypto.h:529: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h:529: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_alloc_ablkcipher’:
include/linux/crypto.h:531: error: ‘type’ undeclared (first use in this function)
include/linux/crypto.h:533: error: ‘mask’ undeclared (first use in this function)
include/linux/crypto.h:536: error: too many arguments to function ‘crypto_alloc_base’
include/linux/crypto.h: At top level:
include/linux/crypto.h:550: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h:551: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_has_ablkcipher’:
include/linux/crypto.h:553: error: ‘type’ undeclared (first use in this function)
include/linux/crypto.h:555: error: ‘mask’ undeclared (first use in this function)
include/linux/crypto.h:557: error: too many arguments to function ‘crypto_has_alg’
include/linux/crypto.h: In function ‘crypto_ablkcipher_crt’:
include/linux/crypto.h:563: error: ‘struct crypto_tfm’ has no member named ‘crt_u’
include/linux/crypto.h: In function ‘crypto_ablkcipher_ivsize’:
include/linux/crypto.h:569: error: ‘struct ablkcipher_tfm’ has no member named ‘ivsize’
include/linux/crypto.h: At top level:
include/linux/crypto.h:584: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘crypto_ablkcipher_get_flags’
include/linux/crypto.h:590: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_ablkcipher_set_flags’:
include/linux/crypto.h:592: error: ‘flags’ undeclared (first use in this function)
include/linux/crypto.h:592: error: too many arguments to function ‘crypto_tfm_set_flags’
include/linux/crypto.h: At top level:
include/linux/crypto.h:596: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_ablkcipher_clear_flags’:
include/linux/crypto.h:598: error: ‘flags’ undeclared (first use in this function)
include/linux/crypto.h:598: error: too many arguments to function ‘crypto_tfm_clear_flags’
include/linux/crypto.h: At top level:
include/linux/crypto.h:602: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:602: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h: In function ‘crypto_ablkcipher_encrypt’:
include/linux/crypto.h:617: error: ‘struct ablkcipher_tfm’ has no member named ‘encrypt’
include/linux/crypto.h: In function ‘crypto_ablkcipher_decrypt’:
include/linux/crypto.h:624: error: ‘struct ablkcipher_tfm’ has no member named ‘decrypt’
include/linux/crypto.h: In function ‘crypto_ablkcipher_reqsize’:
include/linux/crypto.h:630: error: ‘struct ablkcipher_tfm’ has no member named ‘reqsize’
include/linux/crypto.h: In function ‘ablkcipher_request_alloc’:
include/linux/crypto.h:650: error: implicit declaration of function ‘kmalloc’
include/linux/crypto.h:651: warning: assignment makes pointer from integer without a cast
include/linux/crypto.h: At top level:
include/linux/crypto.h:666: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘ablkcipher_request_set_callback’:
include/linux/crypto.h:670: error: ‘struct crypto_async_request’ has no member named ‘flags’
include/linux/crypto.h:670: error: ‘flags’ undeclared (first use in this function)
include/linux/crypto.h: At top level:
include/linux/crypto.h:690: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h:690: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_alloc_aead’:
include/linux/crypto.h:692: error: ‘type’ undeclared (first use in this function)
include/linux/crypto.h:694: error: ‘mask’ undeclared (first use in this function)
include/linux/crypto.h:696: error: too many arguments to function ‘crypto_alloc_base’
include/linux/crypto.h: In function ‘crypto_aead_crt’:
include/linux/crypto.h:711: error: ‘struct crypto_tfm’ has no member named ‘crt_u’
include/linux/crypto.h: In function ‘crypto_aead_ivsize’:
include/linux/crypto.h:716: error: ‘struct aead_tfm’ has no member named ‘ivsize’
include/linux/crypto.h: In function ‘crypto_aead_authsize’:
include/linux/crypto.h:721: error: ‘struct aead_tfm’ has no member named ‘authsize’
include/linux/crypto.h: At top level:
include/linux/crypto.h:734: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘crypto_aead_get_flags’
include/linux/crypto.h:739: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_aead_set_flags’:
include/linux/crypto.h:741: error: ‘flags’ undeclared (first use in this function)
include/linux/crypto.h:741: error: too many arguments to function ‘crypto_tfm_set_flags’
include/linux/crypto.h: At top level:
include/linux/crypto.h:744: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_aead_clear_flags’:
include/linux/crypto.h:746: error: ‘flags’ undeclared (first use in this function)
include/linux/crypto.h:746: error: too many arguments to function ‘crypto_tfm_clear_flags’
include/linux/crypto.h: At top level:
include/linux/crypto.h:749: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:749: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h: In function ‘crypto_aead_encrypt’:
include/linux/crypto.h:762: error: ‘struct aead_tfm’ has no member named ‘encrypt’
include/linux/crypto.h: In function ‘crypto_aead_decrypt’:
include/linux/crypto.h:767: error: ‘struct aead_tfm’ has no member named ‘decrypt’
include/linux/crypto.h: In function ‘crypto_aead_reqsize’:
include/linux/crypto.h:772: error: ‘struct aead_tfm’ has no member named ‘reqsize’
include/linux/crypto.h: In function ‘aead_request_alloc’:
include/linux/crypto.h:786: warning: assignment makes pointer from integer without a cast
include/linux/crypto.h: At top level:
include/linux/crypto.h:800: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘aead_request_set_callback’:
include/linux/crypto.h:806: error: ‘struct crypto_async_request’ has no member named ‘flags’
include/linux/crypto.h:806: error: ‘flags’ undeclared (first use in this function)
include/linux/crypto.h: At top level:
include/linux/crypto.h:812: error: expected declaration specifiers or ‘...’ before ‘u8’
include/linux/crypto.h: In function ‘aead_request_set_crypt’:
include/linux/crypto.h:814: error: ‘struct aead_request’ has no member named ‘src’
include/linux/crypto.h:815: error: ‘struct aead_request’ has no member named ‘dst’
include/linux/crypto.h:817: error: ‘struct aead_request’ has no member named ‘iv’
include/linux/crypto.h:817: error: ‘iv’ undeclared (first use in this function)
include/linux/crypto.h: In function ‘aead_request_set_assoc’:
include/linux/crypto.h:824: error: ‘struct aead_request’ has no member named ‘assoc’
include/linux/crypto.h: In function ‘crypto_blkcipher_cast’:
include/linux/crypto.h:837: error: implicit declaration of function ‘crypto_tfm_alg_type’
include/linux/crypto.h: At top level:
include/linux/crypto.h:842: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h:842: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_alloc_blkcipher’:
include/linux/crypto.h:844: error: ‘type’ undeclared (first use in this function)
include/linux/crypto.h:846: error: ‘mask’ undeclared (first use in this function)
include/linux/crypto.h:848: error: too many arguments to function ‘crypto_alloc_base’
include/linux/crypto.h: At top level:
include/linux/crypto.h:862: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h:862: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_has_blkcipher’:
include/linux/crypto.h:864: error: ‘type’ undeclared (first use in this function)
include/linux/crypto.h:866: error: ‘mask’ undeclared (first use in this function)
include/linux/crypto.h:868: error: too many arguments to function ‘crypto_has_alg’
include/linux/crypto.h: In function ‘crypto_blkcipher_crt’:
include/linux/crypto.h:879: error: ‘struct crypto_tfm’ has no member named ‘crt_u’
include/linux/crypto.h: In function ‘crypto_blkcipher_alg’:
include/linux/crypto.h:885: error: ‘struct crypto_tfm’ has no member named ‘__crt_alg’
include/linux/crypto.h: In function ‘crypto_blkcipher_ivsize’:
include/linux/crypto.h:890: error: ‘struct blkcipher_alg’ has no member named ‘ivsize’
include/linux/crypto.h: At top level:
include/linux/crypto.h:905: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘crypto_blkcipher_get_flags’
include/linux/crypto.h:911: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_blkcipher_set_flags’:
include/linux/crypto.h:913: error: ‘flags’ undeclared (first use in this function)
include/linux/crypto.h:913: error: too many arguments to function ‘crypto_tfm_set_flags’
include/linux/crypto.h: At top level:
include/linux/crypto.h:917: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_blkcipher_clear_flags’:
include/linux/crypto.h:919: error: ‘flags’ undeclared (first use in this function)
include/linux/crypto.h:919: error: too many arguments to function ‘crypto_tfm_clear_flags’
include/linux/crypto.h: At top level:
include/linux/crypto.h:923: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:923: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h: In function ‘crypto_blkcipher_encrypt’:
include/linux/crypto.h:935: error: ‘struct blkcipher_tfm’ has no member named ‘encrypt’
include/linux/crypto.h: In function ‘crypto_blkcipher_encrypt_iv’:
include/linux/crypto.h:943: error: ‘struct blkcipher_tfm’ has no member named ‘encrypt’
include/linux/crypto.h: In function ‘crypto_blkcipher_decrypt’:
include/linux/crypto.h:952: error: ‘struct blkcipher_tfm’ has no member named ‘decrypt’
include/linux/crypto.h: In function ‘crypto_blkcipher_decrypt_iv’:
include/linux/crypto.h:960: error: ‘struct blkcipher_tfm’ has no member named ‘decrypt’
include/linux/crypto.h: At top level:
include/linux/crypto.h:964: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:964: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:970: error: expected declaration specifiers or ‘...’ before ‘u8’
include/linux/crypto.h: In function ‘crypto_blkcipher_get_iv’:
include/linux/crypto.h:972: error: ‘dst’ undeclared (first use in this function)
include/linux/crypto.h:972: error: too many arguments to function ‘memcpy’
include/linux/crypto.h: At top level:
include/linux/crypto.h:987: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h:987: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_alloc_cipher’:
include/linux/crypto.h:989: error: ‘type’ undeclared (first use in this function)
include/linux/crypto.h:991: error: ‘mask’ undeclared (first use in this function)
include/linux/crypto.h:993: error: too many arguments to function ‘crypto_alloc_base’
include/linux/crypto.h: At top level:
include/linux/crypto.h:1006: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h:1006: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_has_cipher’:
include/linux/crypto.h:1008: error: ‘type’ undeclared (first use in this function)
include/linux/crypto.h:1010: error: ‘mask’ undeclared (first use in this function)
include/linux/crypto.h:1012: error: too many arguments to function ‘crypto_has_alg’
include/linux/crypto.h: In function ‘crypto_cipher_crt’:
include/linux/crypto.h:1017: error: ‘struct crypto_tfm’ has no member named ‘crt_u’
include/linux/crypto.h: At top level:
include/linux/crypto.h:1030: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘crypto_cipher_get_flags’
include/linux/crypto.h:1036: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_cipher_set_flags’:
include/linux/crypto.h:1038: error: ‘flags’ undeclared (first use in this function)
include/linux/crypto.h:1038: error: too many arguments to function ‘crypto_tfm_set_flags’
include/linux/crypto.h: At top level:
include/linux/crypto.h:1042: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_cipher_clear_flags’:
include/linux/crypto.h:1044: error: ‘flags’ undeclared (first use in this function)
include/linux/crypto.h:1044: error: too many arguments to function ‘crypto_tfm_clear_flags’
include/linux/crypto.h: At top level:
include/linux/crypto.h:1048: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:1048: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:1055: error: expected declaration specifiers or ‘...’ before ‘u8’
include/linux/crypto.h:1055: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:1055: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:1062: error: expected declaration specifiers or ‘...’ before ‘u8’
include/linux/crypto.h:1062: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:1062: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:1081: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h:1081: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_alloc_hash’:
include/linux/crypto.h:1083: error: ‘type’ undeclared (first use in this function)
include/linux/crypto.h:1085: error: ‘mask’ undeclared (first use in this function)
include/linux/crypto.h:1087: error: too many arguments to function ‘crypto_alloc_base’
include/linux/crypto.h: At top level:
include/linux/crypto.h:1100: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h:1100: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_has_hash’:
include/linux/crypto.h:1102: error: ‘type’ undeclared (first use in this function)
include/linux/crypto.h:1104: error: ‘mask’ undeclared (first use in this function)
include/linux/crypto.h:1106: error: too many arguments to function ‘crypto_has_alg’
include/linux/crypto.h: In function ‘crypto_hash_crt’:
include/linux/crypto.h:1111: error: ‘struct crypto_tfm’ has no member named ‘crt_u’
include/linux/crypto.h: In function ‘crypto_hash_digestsize’:
include/linux/crypto.h:1126: error: ‘struct hash_tfm’ has no member named ‘digestsize’
include/linux/crypto.h: At top level:
include/linux/crypto.h:1129: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘crypto_hash_get_flags’
include/linux/crypto.h:1134: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_hash_set_flags’:
include/linux/crypto.h:1136: error: ‘flags’ undeclared (first use in this function)
include/linux/crypto.h:1136: error: too many arguments to function ‘crypto_tfm_set_flags’
include/linux/crypto.h: At top level:
include/linux/crypto.h:1139: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_hash_clear_flags’:
include/linux/crypto.h:1141: error: ‘flags’ undeclared (first use in this function)
include/linux/crypto.h:1141: error: too many arguments to function ‘crypto_tfm_clear_flags’
include/linux/crypto.h: At top level:
include/linux/crypto.h:1156: error: expected declaration specifiers or ‘...’ before ‘u8’
include/linux/crypto.h: In function ‘crypto_hash_final’:
include/linux/crypto.h:1158: error: ‘out’ undeclared (first use in this function)
include/linux/crypto.h:1158: error: too many arguments to function ‘crypto_hash_crt(desc->tfm)->final’
include/linux/crypto.h: At top level:
include/linux/crypto.h:1163: error: expected declaration specifiers or ‘...’ before ‘u8’
include/linux/crypto.h: In function ‘crypto_hash_digest’:
include/linux/crypto.h:1165: error: ‘out’ undeclared (first use in this function)
include/linux/crypto.h:1165: error: too many arguments to function ‘crypto_hash_crt(desc->tfm)->digest’
include/linux/crypto.h: At top level:
include/linux/crypto.h:1169: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:1169: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:1187: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h:1187: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_alloc_comp’:
include/linux/crypto.h:1189: error: ‘type’ undeclared (first use in this function)
include/linux/crypto.h:1191: error: ‘mask’ undeclared (first use in this function)
include/linux/crypto.h:1193: error: too many arguments to function ‘crypto_alloc_base’
include/linux/crypto.h: At top level:
include/linux/crypto.h:1206: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h:1206: error: expected declaration specifiers or ‘...’ before ‘u32’
include/linux/crypto.h: In function ‘crypto_has_comp’:
include/linux/crypto.h:1208: error: ‘type’ undeclared (first use in this function)
include/linux/crypto.h:1210: error: ‘mask’ undeclared (first use in this function)
include/linux/crypto.h:1212: error: too many arguments to function ‘crypto_has_alg’
include/linux/crypto.h: In function ‘crypto_comp_crt’:
include/linux/crypto.h:1222: error: ‘struct crypto_tfm’ has no member named ‘crt_u’
include/linux/crypto.h: At top level:
include/linux/crypto.h:1226: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:1226: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
include/linux/crypto.h:1234: warning: type defaults to ‘int’ in declaration of ‘u8’
include/linux/crypto.h:1234: error: expected ‘;’, ‘,’ or ‘)’ before ‘*’ token
In file included from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/sched.h:46:36: error: asm/param.h: No such file or directory
In file included from include/linux/sched.h:48,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/capability.h:35: error: expected specifier-qualifier-list before ‘__u32’
include/linux/capability.h:40: error: expected specifier-qualifier-list before ‘__u32’
include/linux/capability.h:59: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘kernel_cap_t’
include/linux/capability.h:296: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘cap_bset’
include/linux/capability.h:324: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘cap_combine’
include/linux/capability.h:331: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘cap_intersect’
include/linux/capability.h:338: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘cap_drop’
include/linux/capability.h:345: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘cap_invert’
In file included from include/linux/sched.h:52,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/timex.h:187:23: error: asm/timex.h: No such file or directory
In file included from include/linux/sched.h:52,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/timex.h:237: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘current_tick_length’
In file included from include/linux/jiffies.h:4,
                 from include/linux/sched.h:53,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/calc64.h:5:23: error: asm/div64.h: No such file or directory
In file included from include/linux/jiffies.h:4,
                 from include/linux/sched.h:53,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/calc64.h: In function ‘do_div_llr’:
include/linux/calc64.h:23: error: ‘u64’ undeclared (first use in this function)
include/linux/calc64.h:23: error: expected ‘;’ before ‘result’
include/linux/calc64.h:25: error: implicit declaration of function ‘do_div’
include/linux/calc64.h:25: error: ‘result’ undeclared (first use in this function)
In file included from include/linux/sched.h:53,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/jiffies.h:18:5: warning: "HZ" is not defined
include/linux/jiffies.h:20:7: warning: "HZ" is not defined
include/linux/jiffies.h:22:7: warning: "HZ" is not defined
include/linux/jiffies.h:24:7: warning: "HZ" is not defined
include/linux/jiffies.h:26:7: warning: "HZ" is not defined
include/linux/jiffies.h:28:7: warning: "HZ" is not defined
include/linux/jiffies.h:30:7: warning: "HZ" is not defined
include/linux/jiffies.h:33:3: error: #error You lose.
In file included from include/linux/sched.h:53,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/jiffies.h: At top level:
include/linux/jiffies.h:75: warning: type defaults to ‘int’ in declaration of ‘u64’
include/linux/jiffies.h:75: error: expected ‘,’ or ‘;’ before ‘jiffies_64’
include/linux/jiffies.h:78:6: warning: "BITS_PER_LONG" is not defined
include/linux/jiffies.h:79: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘get_jiffies_64’
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CLOCK_TICK_RATE" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: warning: "HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:46: warning: "SHIFT_HZ" is not defined
include/linux/jiffies.h:252:5: warning: "BITS_PER_LONG" is not defined
include/linux/jiffies.h:274: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘jiffies_to_clock_t’
include/linux/jiffies.h:276: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘jiffies_64_to_clock_t’
include/linux/jiffies.h:277: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘nsec_to_clock_t’
In file included from include/linux/sched.h:59,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/mm_types.h:14:21: error: asm/mmu.h: No such file or directory
In file included from include/linux/sched.h:59,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/mm_types.h:19: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘mm_counter_t’
include/linux/mm_types.h:34: error: expected specifier-qualifier-list before ‘atomic_t’
include/linux/mm_types.h:103: error: expected specifier-qualifier-list before ‘pgprot_t’
include/linux/mm_types.h:163: error: expected specifier-qualifier-list before ‘pgd_t’
In file included from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/sched.h:62:27: error: asm/semaphore.h: No such file or directory
include/linux/sched.h:64:24: error: asm/ptrace.h: No such file or directory
include/linux/sched.h:65:25: error: asm/cputime.h: No such file or directory
In file included from include/linux/sem.h:4,
                 from include/linux/sched.h:68,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/ipc.h:12: error: expected specifier-qualifier-list before ‘__kernel_uid_t’
In file included from include/linux/sem.h:4,
                 from include/linux/sched.h:68,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/ipc.h:21:24: error: asm/ipcbuf.h: No such file or directory
include/linux/ipc.h:65: error: expected specifier-qualifier-list before ‘uid_t’
include/linux/ipc.h:86: error: expected specifier-qualifier-list before ‘size_t’
In file included from include/linux/sched.h:68,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/sem.h:25: error: expected specifier-qualifier-list before ‘__kernel_time_t’
In file included from include/linux/sched.h:68,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/sem.h:35:24: error: asm/sembuf.h: No such file or directory
include/linux/sem.h:94: error: expected specifier-qualifier-list before ‘time_t’
include/linux/sem.h:132: error: expected specifier-qualifier-list before ‘atomic_t’
In file included from include/linux/sched.h:69,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/signal.h:4:24: error: asm/signal.h: No such file or directory
include/linux/signal.h:5:25: error: asm/siginfo.h: No such file or directory
In file included from include/linux/sched.h:69,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/signal.h:17: error: expected specifier-qualifier-list before ‘siginfo_t’
include/linux/signal.h:26: error: expected specifier-qualifier-list before ‘sigset_t’
include/linux/signal.h:38: error: expected ‘)’ before ‘*’ token
include/linux/signal.h:47: error: expected ‘)’ before ‘*’ token
include/linux/signal.h:56: error: expected ‘)’ before ‘*’ token
include/linux/signal.h: In function ‘sigfindinword’:
include/linux/signal.h:67: error: implicit declaration of function ‘ffz’
include/linux/signal.h: At top level:
include/linux/signal.h:72: error: expected ‘)’ before ‘*’ token
include/linux/signal.h:119: error: expected ‘)’ before ‘*’ token
include/linux/signal.h:122: error: expected ‘)’ before ‘*’ token
include/linux/signal.h:125: error: expected ‘)’ before ‘*’ token
include/linux/signal.h:149: error: expected ‘)’ before ‘*’ token
include/linux/signal.h:154: error: expected ‘)’ before ‘*’ token
include/linux/signal.h:166: error: expected ‘)’ before ‘*’ token
include/linux/signal.h:180: error: expected ‘)’ before ‘*’ token
include/linux/signal.h:185: error: expected ‘)’ before ‘*’ token
include/linux/signal.h:190: error: expected ‘)’ before ‘*’ token
include/linux/signal.h:195: error: expected ‘)’ before ‘*’ token
include/linux/signal.h:207: error: expected ‘)’ before ‘*’ token
include/linux/signal.h: In function ‘init_sigpending’:
include/linux/signal.h:223: error: implicit declaration of function ‘sigemptyset’
include/linux/signal.h:223: error: ‘struct sigpending’ has no member named ‘signal’
include/linux/signal.h: In function ‘valid_signal’:
include/linux/signal.h:232: error: ‘_NSIG’ undeclared (first use in this function)
include/linux/signal.h: At top level:
include/linux/signal.h:235: error: expected declaration specifiers or ‘...’ before ‘sigset_t’
include/linux/signal.h:236: warning: ‘struct siginfo’ declared inside parameter list
include/linux/signal.h:237: warning: ‘struct siginfo’ declared inside parameter list
include/linux/signal.h:239: error: expected declaration specifiers or ‘...’ before ‘sigset_t’
include/linux/signal.h:239: error: expected declaration specifiers or ‘...’ before ‘sigset_t’
include/linux/signal.h:243: error: expected ‘)’ before ‘*’ token
include/linux/signal.h:329:5: warning: "SIGRTMIN" is not defined
include/linux/signal.h:329:16: warning: "BITS_PER_LONG" is not defined
In file included from include/linux/sched.h:71,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/fs_struct.h:8: error: expected specifier-qualifier-list before ‘atomic_t’
In file included from include/linux/rcupdate.h:41,
                 from include/linux/pid.h:4,
                 from include/linux/sched.h:74,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/percpu.h:10:24: error: asm/percpu.h: No such file or directory
In file included from include/linux/rcupdate.h:41,
                 from include/linux/pid.h:4,
                 from include/linux/sched.h:74,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/percpu.h:52: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/percpu.h:54: error: expected declaration specifiers or ‘...’ before ‘size_t’
include/linux/percpu.h:57: error: expected ‘)’ before ‘size’
In file included from include/linux/pid.h:4,
                 from include/linux/sched.h:74,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/rcupdate.h:72: error: requested alignment is not a constant
include/linux/rcupdate.h:75: error: requested alignment is not a constant
include/linux/rcupdate.h:114: error: expected declaration specifiers or ‘...’ before ‘rcu_data’
include/linux/rcupdate.h:114: warning: data definition has no type or storage class
include/linux/rcupdate.h:114: warning: type defaults to ‘int’ in declaration of ‘DECLARE_PER_CPU’
include/linux/rcupdate.h:115: error: expected declaration specifiers or ‘...’ before ‘rcu_bh_data’
include/linux/rcupdate.h:115: warning: data definition has no type or storage class
include/linux/rcupdate.h:115: warning: type defaults to ‘int’ in declaration of ‘DECLARE_PER_CPU’
include/linux/rcupdate.h: In function ‘rcu_qsctr_inc’:
include/linux/rcupdate.h:125: error: implicit declaration of function ‘per_cpu’
include/linux/rcupdate.h:125: error: ‘rcu_data’ undeclared (first use in this function)
include/linux/rcupdate.h:125: error: invalid lvalue in unary ‘&’
include/linux/rcupdate.h: In function ‘rcu_bh_qsctr_inc’:
include/linux/rcupdate.h:130: error: ‘rcu_bh_data’ undeclared (first use in this function)
include/linux/rcupdate.h:130: error: invalid lvalue in unary ‘&’
In file included from include/linux/sched.h:74,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/pid.h: At top level:
include/linux/pid.h:45: error: expected specifier-qualifier-list before ‘atomic_t’
include/linux/pid.h: In function ‘get_pid’:
include/linux/pid.h:65: error: implicit declaration of function ‘atomic_inc’
include/linux/pid.h:65: error: ‘struct pid’ has no member named ‘count’
include/linux/pid.h: At top level:
include/linux/pid.h:101: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘pid_nr’
In file included from include/linux/sched.h:77,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/seccomp.h:8:25: error: asm/seccomp.h: No such file or directory
In file included from include/linux/sched.h:77,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/seccomp.h: In function ‘secure_computing’:
include/linux/seccomp.h:15: error: ‘TIF_SECCOMP’ undeclared (first use in this function)
include/linux/seccomp.h:15: warning: passing argument 1 of ‘test_ti_thread_flag’ makes pointer from integer without a cast
In file included from include/linux/sched.h:79,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/futex.h: At top level:
include/linux/futex.h:111: error: expected ‘)’ before ‘*’ token
include/linux/futex.h:115: error: expected ‘)’ before ‘*’ token
include/linux/futex.h:152: error: expected ‘)’ before ‘*’ token
In file included from include/linux/sched.h:84,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/resource.h:70:26: error: asm/resource.h: No such file or directory
In file included from include/linux/timer.h:5,
                 from include/linux/sched.h:85,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/ktime.h:47: error: expected specifier-qualifier-list before ‘s64’
In file included from include/linux/timer.h:5,
                 from include/linux/sched.h:85,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/ktime.h:48:5: warning: "BITS_PER_LONG" is not defined
include/linux/ktime.h:62:6: warning: "BITS_PER_LONG" is not defined
include/linux/ktime.h:72:6: warning: "BITS_PER_LONG" is not defined
include/linux/ktime.h: In function ‘ktime_set’:
include/linux/ktime.h:153: error: unknown field ‘tv’ specified in initializer
include/linux/ktime.h:153: error: extra brace group at end of initializer
include/linux/ktime.h:153: error: (near initialization for ‘(anonymous)’)
include/linux/ktime.h:153: warning: excess elements in union initializer
include/linux/ktime.h:153: warning: (near initialization for ‘(anonymous)’)
include/linux/ktime.h: In function ‘ktime_sub’:
include/linux/ktime.h:167: error: ‘ktime_t’ has no member named ‘tv64’
include/linux/ktime.h:167: error: ‘ktime_t’ has no member named ‘tv64’
include/linux/ktime.h:167: error: ‘ktime_t’ has no member named ‘tv64’
include/linux/ktime.h:168: error: ‘ktime_t’ has no member named ‘tv’
include/linux/ktime.h:169: error: ‘ktime_t’ has no member named ‘tv’
include/linux/ktime.h: In function ‘ktime_add’:
include/linux/ktime.h:185: error: ‘ktime_t’ has no member named ‘tv64’
include/linux/ktime.h:185: error: ‘ktime_t’ has no member named ‘tv64’
include/linux/ktime.h:185: error: ‘ktime_t’ has no member named ‘tv64’
include/linux/ktime.h:194: error: ‘ktime_t’ has no member named ‘tv’
include/linux/ktime.h:195: error: ‘ktime_t’ has no member named ‘tv64’
include/linux/ktime.h:195: error: ‘u32’ undeclared (first use in this function)
include/linux/ktime.h: At top level:
include/linux/ktime.h:207: error: expected declaration specifiers or ‘...’ before ‘u64’
include/linux/ktime.h:216: error: expected declaration specifiers or ‘...’ before ‘u64’
include/linux/ktime.h: In function ‘timespec_to_ktime’:
include/linux/ktime.h:226: error: unknown field ‘tv’ specified in initializer
include/linux/ktime.h:226: error: extra brace group at end of initializer
include/linux/ktime.h:226: error: (near initialization for ‘(anonymous)’)
include/linux/ktime.h:226: error: ‘s32’ undeclared (first use in this function)
include/linux/ktime.h:226: error: expected ‘}’ before ‘ts’
include/linux/ktime.h:227: confused by earlier errors, bailing out
make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2


