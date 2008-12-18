Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753323AbYLRAaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYLRAaz (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 19:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYLRAam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 19:30:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60738 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbYLRAaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 19:30:39 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: dhowells@redhat.com, Trond Myklebust <trond.myklebust@fys.uio.no>,
        steved@redhat.com, rwheeler@redhat.com, bfields@fieldses.org,
        nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Pull request for FS-Cache, including NFS patches
Date: Thu, 18 Dec 2008 00:30:21 +0000
Message-ID: <8930.1229560221@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Stephen,

Can you try pulling the master branch of this tree:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-nfs-fscache.git

into linux-next, please?

This tree includes the following:

 (1) The 'next' branch of the security tree, which you already have.

 (2) The 'linux-next' branch of the NFS tree, which you already have.

 (3) My FS-Cache, CacheFiles and AFS patches, and associated enablement
     patches.

 (4) My patches to enable NFS to use FS-Cache.

I've tried merging into next-20081217, and it just applied and the tests
worked upon it.

David
---
The following changes since commit 1bda71282ded6a2e09a2db7c8884542fb46bfd4f:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../ieee1394/linux1394-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-nfs-fscache.git master

Al Viro (1):
      Audit: Log TIOCSTI

David Howells (123):
      CRED: Wrap task credential accesses in the IA64 arch
      CRED: Wrap task credential accesses in the MIPS arch
      CRED: Wrap task credential accesses in the PA-RISC arch
      CRED: Wrap task credential accesses in the PowerPC arch
      CRED: Wrap task credential accesses in the S390 arch
      CRED: Wrap task credential accesses in the x86 arch
      CRED: Wrap task credential accesses in the block loopback driver
      CRED: Wrap task credential accesses in the tty driver
      CRED: Wrap task credential accesses in the ISDN drivers
      CRED: Wrap task credential accesses in the network device drivers
      CRED: Wrap task credential accesses in the USB driver
      CRED: Wrap task credential accesses in 9P2000 filesystem
      CRED: Wrap task credential accesses in the AFFS filesystem
      CRED: Wrap task credential accesses in the autofs filesystem
      CRED: Wrap task credential accesses in the autofs4 filesystem
      CRED: Wrap task credential accesses in the BFS filesystem
      CRED: Wrap task credential accesses in the CIFS filesystem
      CRED: Wrap task credential accesses in the Coda filesystem
      CRED: Wrap task credential accesses in the devpts filesystem
      CRED: Wrap task credential accesses in the eCryptFS filesystem
      CRED: Wrap task credential accesses in the Ext2 filesystem
      CRED: Wrap task credential accesses in the Ext3 filesystem
      CRED: Wrap task credential accesses in the Ext4 filesystem
      CRED: Wrap task credential accesses in the FAT filesystem
      CRED: Wrap task credential accesses in the FUSE filesystem
      CRED: Wrap task credential accesses in the GFS2 filesystem
      CRED: Wrap task credential accesses in the HFS filesystem
      CRED: Wrap task credential accesses in the HFSplus filesystem
      CRED: Wrap task credential accesses in the HPFS filesystem
      CRED: Wrap task credential accesses in the hugetlbfs filesystem
      CRED: Wrap task credential accesses in the JFS filesystem
      CRED: Wrap task credential accesses in the Minix filesystem
      CRED: Wrap task credential accesses in the NCPFS filesystem
      CRED: Wrap task credential accesses in the NFS daemon
      CRED: Wrap task credential accesses in the OCFS2 filesystem
      CRED: Wrap task credential accesses in the OMFS filesystem
      CRED: Wrap task credential accesses in the RAMFS filesystem
      CRED: Wrap task credential accesses in the ReiserFS filesystem
      CRED: Wrap task credential accesses in the SMBFS filesystem
      CRED: Wrap task credential accesses in the SYSV filesystem
      CRED: Wrap task credential accesses in the UBIFS filesystem
      CRED: Wrap task credential accesses in the UDF filesystem
      CRED: Wrap task credential accesses in the UFS filesystem
      CRED: Wrap task credential accesses in the XFS filesystem
      CRED: Wrap task credential accesses in the filesystem subsystem
      CRED: Wrap task credential accesses in the SYSV IPC subsystem
      CRED: Wrap task credential accesses in the AX25 protocol
      CRED: Wrap task credential accesses in the IPv6 protocol
      CRED: Wrap task credential accesses in the netrom protocol
      CRED: Wrap task credential accesses in the ROSE protocol
      CRED: Wrap task credential accesses in the SunRPC protocol
      CRED: Wrap task credential accesses in the UNIX socket protocol
      CRED: Wrap task credential accesses in the networking subsystem
      CRED: Wrap task credential accesses in the key management code
      CRED: Wrap task credential accesses in the capabilities code
      CRED: Wrap task credential accesses in the core kernel
      KEYS: Disperse linux/key_ui.h
      KEYS: Alter use of key instantiation link-to-keyring argument
      CRED: Neuter sys_capset()
      CRED: Constify the kernel_cap_t arguments to the capset LSM hooks
      CRED: Separate task security context from task_struct
      CRED: Detach the credentials from task_struct
      CRED: Wrap current->cred and a few other accessors
      CRED: Use RCU to access another task's creds and to release a task's own creds
      CRED: Wrap access to SELinux's task SID
      CRED: Separate per-task-group keyrings from signal_struct
      CRED: Rename is_single_threaded() to is_wq_single_threaded()
      CRED: Make inode_has_perm() and file_has_perm() take a cred pointer
      CRED: Pass credentials through dentry_open()
      CRED: Inaugurate COW credentials
      CRED: Make execve() take advantage of copy-on-write credentials
      CRED: Prettify commoncap.c
      CRED: Use creds in file structs
      CRED: Documentation
      CRED: Differentiate objective and effective subjective credentials on a task
      CRED: Add a kernel_service object class to SELinux
      CRED: Allow kernel services to override LSM settings for task actions
      Merge branch 'master' of /warthog/git/security-testing-2.6-next
      Create a dynamically sized pool of threads for doing very slow work items
      Make slow-work thread pool actually dynamic
      Make the slow work pool configurable
      Document the slow work thread pool
      FS-Cache: Release page->private after failed readahead
      FS-Cache: Recruit a couple of page flags for cache management
      FS-Cache: Add the FS-Cache netfs API and documentation
      FS-Cache: Add the FS-Cache cache backend API and documentation
      FS-Cache: Add main configuration option, module entry points and debugging
      FS-Cache: Add use of /proc and presentation of statistics
      FS-Cache: Root index definition
      FS-Cache: Add cache tag handling
      FS-Cache: Add cache management
      FS-Cache: Provide a slab for cookie allocation
      FS-Cache: Add netfs registration
      FS-Cache: Bit waiting helpers
      FS-Cache: Object management state machine
      FS-Cache: Implement the cookie management part of the netfs API
      FS-Cache: Add and document asynchronous operation handling
      FS-Cache: Implement data I/O part of netfs API
      CacheFiles: Be consistent about the use of mapping vs file->f_mapping in Ext3
      CacheFiles: Add a hook to write a single page of data to an inode
      CacheFiles: Permit the page lock state to be monitored
      CacheFiles: Export things for CacheFiles
      CacheFiles: A cache that backs onto a mounted filesystem
      FS-Cache: Make kAFS use FS-Cache
      NFS: Add comment banners to some NFS functions
      NFS: Add FS-Cache option bit and debug bit
      NFS: Permit local filesystem caching to be enabled for NFS
      NFS: Register NFS for caching and retrieve the top-level index
      NFS: Define and create server-level objects
      NFS: Define and create superblock-level objects
      NFS: Define and create inode-level cache objects
      NFS: Use local disk inode cache
      NFS: Invalidate FsCache page flags when cache removed
      NFS: Add some new I/O counters for FS-Cache doing things for NFS
      NFS: FS-Cache page management
      NFS: Add read context retention for FS-Cache to call back with
      NFS: nfs_readpage_async() needs to be accessible as a fallback for local caching
      NFS: Read pages from FS-Cache into an NFS inode
      NFS: Store pages from an NFS inode into a local cache
      NFS: Display local caching state
      NFS: Add mount options to enable local caching on NFS
      Merge branch 'master' of /warthog/git/security-testing-2.6-next
      Merge branch 'master' of /warthog/nfs/linux-2.6-fscache

Eric Paris (13):
      SELinux: check open perms in dentry_open not inode_permission
      SELinux: hold tasklist_lock and siglock while waking wait_chldexit
      SELinux: Use unknown perm handling to handle unknown netlink msg types
      Document the order of arguments for cap_issubset.  It's not instantly clear
      This patch add a generic cpu endian caps structure and externally available
      This patch will print cap_permitted and cap_inheritable data in the PATH
      Any time fcaps or a setuid app under SECURE_NOROOT is used to result in a
      When the capset syscall is used it is not possible for audit to record the
      Capabilities: BUG when an invalid capability is requested
      Add a new capable interface that will be used by systems that use audit to
      The oomkiller calculations make decisions based on capabilities.  Since
      Currently SELinux jumps through some ugly hoops to not audit a capbility
      capabilities: define get_vfs_caps_from_disk when file caps are not enabled

Hannes Eder (1):
      CRED: fix sparse warnings

James Morris (6):
      Merge branch 'master' into next
      security: remove broken and useless declarations
      Merge branch 'master' into next
      Merge branch 'master' into next
      Merge branch 'serge-next' into next
      Merge branch 'master' into next

Michal Schmidt (1):
      selinux: recognize netlink messages for 'ip addrlabel'

Prarit Bhargava (1):
      CacheFiles: Add missing copy_page export for ia64

Randy Dunlap (2):
      coda: fix creds reference
      nfsctl: add headers for credentials

Serge E. Hallyn (4):
      file capabilities: add no_file_caps switch (v4)
      user namespaces: let user_ns be cloned with fairsched
      user namespaces: require cap_set{ug}id for CLONE_NEWUSER
      user namespaces: document CFS behavior

Serge Hallyn (2):
      User namespaces: set of cleanups (v2)
      User namespaces: use the current_user_ns() macro

 Documentation/credentials.txt                     |  582 ++++++++++
 Documentation/filesystems/caching/backend-api.txt |  658 +++++++++++
 Documentation/filesystems/caching/cachefiles.txt  |  501 +++++++++
 Documentation/filesystems/caching/fscache.txt     |  333 ++++++
 Documentation/filesystems/caching/netfs-api.txt   |  800 +++++++++++++
 Documentation/filesystems/caching/object.txt      |  313 ++++++
 Documentation/filesystems/caching/operations.txt  |  213 ++++
 Documentation/kernel-parameters.txt               |    4 +
 Documentation/scheduler/sched-design-CFS.txt      |   21 +
 Documentation/slow-work.txt                       |  174 +++
 arch/alpha/kernel/asm-offsets.c                   |   11 +-
 arch/alpha/kernel/entry.S                         |   10 +-
 arch/ia64/ia32/sys_ia32.c                         |    7 +-
 arch/ia64/kernel/ia64_ksyms.c                     |    1 +
 arch/ia64/kernel/mca_drv.c                        |    2 +-
 arch/ia64/kernel/perfmon.c                        |   43 +-
 arch/ia64/kernel/signal.c                         |    4 +-
 arch/mips/kernel/kspd.c                           |    4 +-
 arch/mips/kernel/mips-mt-fpaff.c                  |    5 +-
 arch/mips/kernel/vpe.c                            |    4 +-
 arch/parisc/kernel/signal.c                       |    2 +-
 arch/powerpc/mm/fault.c                           |    2 +-
 arch/powerpc/platforms/cell/spufs/inode.c         |    8 +-
 arch/s390/hypfs/inode.c                           |    4 +-
 arch/s390/kernel/compat_linux.c                   |   28 +-
 arch/um/drivers/mconsole_kern.c                   |    3 +-
 arch/x86/ia32/ia32_aout.c                         |    2 +-
 arch/x86/mm/fault.c                               |    2 +-
 drivers/block/loop.c                              |    6 +-
 drivers/char/tty_audit.c                          |   76 +-
 drivers/char/tty_io.c                             |    1 +
 drivers/connector/cn_proc.c                       |   16 +-
 drivers/isdn/capi/capifs.c                        |    4 +-
 drivers/isdn/hysdn/hysdn_procconf.c               |    6 +-
 drivers/net/tun.c                                 |    8 +-
 drivers/usb/core/devio.c                          |   10 +-
 drivers/usb/core/inode.c                          |    4 +-
 fs/9p/fid.c                                       |    2 +-
 fs/9p/vfs_inode.c                                 |    4 +-
 fs/9p/vfs_super.c                                 |    4 +-
 fs/Kconfig                                        |   24 +
 fs/Makefile                                       |    2 +
 fs/affs/inode.c                                   |    4 +-
 fs/affs/super.c                                   |    4 +-
 fs/afs/Makefile                                   |    3 +
 fs/afs/cache.c                                    |  503 ++++++---
 fs/afs/cache.h                                    |   15 +-
 fs/afs/cell.c                                     |   16 +-
 fs/afs/file.c                                     |  212 +++--
 fs/afs/inode.c                                    |   25 +-
 fs/afs/internal.h                                 |   53 +-
 fs/afs/main.c                                     |   27 +-
 fs/afs/mntpt.c                                    |    4 +-
 fs/afs/vlocation.c                                |   23 +-
 fs/afs/volume.c                                   |   14 +-
 fs/afs/write.c                                    |   19 +
 fs/anon_inodes.c                                  |    4 +-
 fs/attr.c                                         |    4 +-
 fs/autofs/inode.c                                 |    4 +-
 fs/autofs4/dev-ioctl.c                            |    3 +-
 fs/autofs4/inode.c                                |    4 +-
 fs/autofs4/waitq.c                                |    4 +-
 fs/bfs/dir.c                                      |    4 +-
 fs/binfmt_aout.c                                  |    2 +-
 fs/binfmt_elf.c                                   |   20 +-
 fs/binfmt_elf_fdpic.c                             |   19 +-
 fs/binfmt_flat.c                                  |    2 +-
 fs/binfmt_som.c                                   |    2 +-
 fs/cachefiles/Kconfig                             |   39 +
 fs/cachefiles/Makefile                            |   18 +
 fs/cachefiles/cf-bind.c                           |  286 +++++
 fs/cachefiles/cf-daemon.c                         |  754 +++++++++++++
 fs/cachefiles/cf-interface.c                      |  449 ++++++++
 fs/cachefiles/cf-internal.h                       |  360 ++++++
 fs/cachefiles/cf-key.c                            |  159 +++
 fs/cachefiles/cf-main.c                           |  106 ++
 fs/cachefiles/cf-namei.c                          |  772 +++++++++++++
 fs/cachefiles/cf-proc.c                           |  134 +++
 fs/cachefiles/cf-rdwr.c                           |  853 ++++++++++++++
 fs/cachefiles/cf-security.c                       |  116 ++
 fs/cachefiles/cf-xattr.c                          |  291 +++++
 fs/cifs/cifs_fs_sb.h                              |    2 +-
 fs/cifs/cifsproto.h                               |    2 +-
 fs/cifs/connect.c                                 |    4 +-
 fs/cifs/dir.c                                     |   12 +-
 fs/cifs/inode.c                                   |    8 +-
 fs/cifs/ioctl.c                                   |    2 +-
 fs/cifs/misc.c                                    |    4 +-
 fs/coda/cache.c                                   |    6 +-
 fs/coda/file.c                                    |    3 +-
 fs/coda/upcall.c                                  |    2 +-
 fs/compat.c                                       |   42 +-
 fs/devpts/inode.c                                 |    4 +-
 fs/dquot.c                                        |    4 +-
 fs/ecryptfs/ecryptfs_kernel.h                     |    3 +-
 fs/ecryptfs/kthread.c                             |    9 +-
 fs/ecryptfs/main.c                                |    3 +-
 fs/ecryptfs/messaging.c                           |   27 +-
 fs/ecryptfs/miscdev.c                             |   27 +-
 fs/exec.c                                         |  183 ++--
 fs/exportfs/expfs.c                               |    4 +-
 fs/ext2/balloc.c                                  |    2 +-
 fs/ext2/ialloc.c                                  |    4 +-
 fs/ext2/inode.c                                   |    2 +
 fs/ext3/balloc.c                                  |    2 +-
 fs/ext3/ialloc.c                                  |    4 +-
 fs/ext3/inode.c                                   |    9 +-
 fs/ext4/balloc.c                                  |    2 +-
 fs/ext4/ialloc.c                                  |    4 +-
 fs/fat/file.c                                     |    2 +-
 fs/fat/inode.c                                    |    4 +-
 fs/fcntl.c                                        |   18 +-
 fs/file_table.c                                   |   10 +-
 fs/fscache/Kconfig                                |   56 +
 fs/fscache/Makefile                               |   19 +
 fs/fscache/fsc-cache.c                            |  415 +++++++
 fs/fscache/fsc-cookie.c                           |  498 ++++++++
 fs/fscache/fsc-fsdef.c                            |  144 +++
 fs/fscache/fsc-histogram.c                        |  109 ++
 fs/fscache/fsc-internal.h                         |  380 +++++++
 fs/fscache/fsc-main.c                             |  124 ++
 fs/fscache/fsc-netfs.c                            |  103 ++
 fs/fscache/fsc-object.c                           |  810 +++++++++++++
 fs/fscache/fsc-operation.c                        |  459 ++++++++
 fs/fscache/fsc-page.c                             |  771 +++++++++++++
 fs/fscache/fsc-proc.c                             |   68 ++
 fs/fscache/fsc-stats.c                            |  212 ++++
 fs/fuse/dev.c                                     |    4 +-
 fs/fuse/dir.c                                     |   25 +-
 fs/gfs2/inode.c                                   |   10 +-
 fs/hfs/inode.c                                    |    4 +-
 fs/hfs/super.c                                    |    4 +-
 fs/hfsplus/inode.c                                |    4 +-
 fs/hfsplus/options.c                              |    4 +-
 fs/hpfs/namei.c                                   |   24 +-
 fs/hpfs/super.c                                   |    4 +-
 fs/hppfs/hppfs.c                                  |    6 +-
 fs/hugetlbfs/inode.c                              |   21 +-
 fs/inotify_user.c                                 |    2 +-
 fs/internal.h                                     |    6 +
 fs/ioprio.c                                       |   18 +-
 fs/jfs/jfs_inode.c                                |    4 +-
 fs/locks.c                                        |    2 +-
 fs/minix/bitmap.c                                 |    4 +-
 fs/namei.c                                        |   10 +-
 fs/namespace.c                                    |    2 +-
 fs/ncpfs/ioctl.c                                  |   91 +-
 fs/nfs/Makefile                                   |    1 +
 fs/nfs/client.c                                   |   14 +-
 fs/nfs/file.c                                     |   37 +-
 fs/nfs/fscache-index.c                            |  337 ++++++
 fs/nfs/fscache.c                                  |  521 +++++++++
 fs/nfs/fscache.h                                  |  208 ++++
 fs/nfs/inode.c                                    |   17 +-
 fs/nfs/internal.h                                 |    4 +
 fs/nfs/iostat.h                                   |   18 +
 fs/nfs/read.c                                     |   27 +-
 fs/nfs/super.c                                    |   44 +-
 fs/nfsctl.c                                       |    5 +-
 fs/nfsd/auth.c                                    |   95 +-
 fs/nfsd/nfs4recover.c                             |   72 +-
 fs/nfsd/nfsfh.c                                   |   11 +-
 fs/nfsd/vfs.c                                     |    9 +-
 fs/ocfs2/dlm/dlmfs.c                              |    8 +-
 fs/ocfs2/namei.c                                  |    4 +-
 fs/omfs/inode.c                                   |    8 +-
 fs/open.c                                         |   59 +-
 fs/pipe.c                                         |    4 +-
 fs/posix_acl.c                                    |    4 +-
 fs/proc/array.c                                   |   32 +-
 fs/proc/base.c                                    |   32 +-
 fs/quota.c                                        |    4 +-
 fs/ramfs/inode.c                                  |    4 +-
 fs/reiserfs/namei.c                               |    4 +-
 fs/smbfs/dir.c                                    |    3 +-
 fs/smbfs/inode.c                                  |    2 +-
 fs/smbfs/proc.c                                   |    2 +-
 fs/splice.c                                       |    3 +-
 fs/super.c                                        |    1 +
 fs/sysv/ialloc.c                                  |    4 +-
 fs/ubifs/budget.c                                 |    2 +-
 fs/ubifs/dir.c                                    |    4 +-
 fs/udf/ialloc.c                                   |    4 +-
 fs/udf/namei.c                                    |    2 +-
 fs/ufs/ialloc.c                                   |    4 +-
 fs/xfs/linux-2.6/xfs_cred.h                       |    6 +-
 fs/xfs/linux-2.6/xfs_globals.h                    |    2 +-
 fs/xfs/linux-2.6/xfs_ioctl.c                      |    5 +-
 fs/xfs/xfs_acl.c                                  |    6 +-
 fs/xfs/xfs_inode.h                                |    2 +-
 fs/xfs/xfs_vnodeops.h                             |   10 +-
 include/keys/keyring-type.h                       |   31 +
 include/linux/audit.h                             |   26 +
 include/linux/binfmts.h                           |   16 +-
 include/linux/capability.h                        |   25 +-
 include/linux/cred.h                              |  342 ++++++-
 include/linux/fs.h                                |   15 +-
 include/linux/fscache-cache.h                     |  504 +++++++++
 include/linux/fscache.h                           |  592 ++++++++++
 include/linux/init_task.h                         |   14 +-
 include/linux/key-ui.h                            |   66 --
 include/linux/key.h                               |   32 +-
 include/linux/keyctl.h                            |    4 +-
 include/linux/nfs_fs.h                            |   13 +
 include/linux/nfs_fs_sb.h                         |   11 +
 include/linux/nfs_iostat.h                        |   12 +
 include/linux/nsproxy.h                           |    1 -
 include/linux/page-flags.h                        |   44 +-
 include/linux/pagemap.h                           |   21 +
 include/linux/sched.h                             |   65 +-
 include/linux/securebits.h                        |    2 +-
 include/linux/security.h                          |  338 +++---
 include/linux/slow-work.h                         |   95 ++
 include/linux/tty.h                               |    4 +
 include/linux/user_namespace.h                    |   13 +-
 include/net/scm.h                                 |    4 +-
 init/Kconfig                                      |   12 +
 init/main.c                                       |    1 +
 ipc/mqueue.c                                      |   19 +-
 ipc/shm.c                                         |    9 +-
 ipc/util.c                                        |   18 +-
 kernel/Makefile                                   |    3 +-
 kernel/acct.c                                     |    7 +-
 kernel/auditsc.c                                  |  255 ++++-
 kernel/capability.c                               |  288 +----
 kernel/cgroup.c                                   |   17 +-
 kernel/cred-internals.h                           |   21 +
 kernel/cred.c                                     |  588 ++++++++++
 kernel/exit.c                                     |   23 +-
 kernel/fork.c                                     |   62 +-
 kernel/futex.c                                    |   20 +-
 kernel/futex_compat.c                             |    7 +-
 kernel/kmod.c                                     |   30 +-
 kernel/nsproxy.c                                  |   15 +-
 kernel/ptrace.c                                   |   29 +-
 kernel/sched.c                                    |   26 +-
 kernel/signal.c                                   |   60 +-
 kernel/slow-work.c                                |  617 ++++++++++
 kernel/sys.c                                      |  586 ++++++-----
 kernel/sysctl.c                                   |   11 +-
 kernel/timer.c                                    |    8 +-
 kernel/trace/trace.c                              |    2 +-
 kernel/tsacct.c                                   |    6 +-
 kernel/uid16.c                                    |   31 +-
 kernel/user.c                                     |   96 +--
 kernel/user_namespace.c                           |   65 +-
 kernel/workqueue.c                                |    8 +-
 lib/Makefile                                      |    2 +-
 lib/is_single_threaded.c                          |   45 +
 mm/filemap.c                                      |   99 ++
 mm/mempolicy.c                                    |    9 +-
 mm/migrate.c                                      |   19 +-
 mm/oom_kill.c                                     |   12 +-
 mm/readahead.c                                    |   40 +-
 mm/shmem.c                                        |    8 +-
 mm/swap.c                                         |    4 +-
 mm/swap_state.c                                   |    4 +-
 mm/swapfile.c                                     |    4 +-
 mm/truncate.c                                     |   10 +-
 mm/vmscan.c                                       |    6 +-
 net/9p/client.c                                   |    2 +-
 net/ax25/af_ax25.c                                |    2 +-
 net/ax25/ax25_route.c                             |    2 +-
 net/core/dev.c                                    |    8 +-
 net/core/scm.c                                    |   10 +-
 net/ipv4/netfilter/ipt_LOG.c                      |    4 +-
 net/ipv6/ip6_flowlabel.c                          |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c                     |    4 +-
 net/netfilter/nfnetlink_log.c                     |    5 +-
 net/netfilter/xt_owner.c                          |   16 +-
 net/netrom/af_netrom.c                            |    4 +-
 net/rose/af_rose.c                                |    4 +-
 net/rxrpc/ar-key.c                                |    6 +-
 net/sched/cls_flow.c                              |    4 +-
 net/socket.c                                      |    4 +-
 net/sunrpc/auth.c                                 |   14 +-
 net/unix/af_unix.c                                |   11 +-
 security/capability.c                             |   56 +-
 security/commoncap.c                              |  830 +++++++++-----
 security/keys/internal.h                          |   49 +-
 security/keys/key.c                               |   25 +-
 security/keys/keyctl.c                            |  210 +++--
 security/keys/keyring.c                           |   15 +-
 security/keys/permission.c                        |   29 +-
 security/keys/proc.c                              |    8 +-
 security/keys/process_keys.c                      |  469 ++++-----
 security/keys/request_key.c                       |  135 ++-
 security/keys/request_key_auth.c                  |   46 +-
 security/root_plug.c                              |   13 +-
 security/security.c                               |  101 +-
 security/selinux/exports.c                        |    8 +-
 security/selinux/hooks.c                          | 1246 +++++++++++----------
 security/selinux/include/av_perm_to_string.h      |    2 +
 security/selinux/include/av_permissions.h         |    2 +
 security/selinux/include/class_to_string.h        |    5 +
 security/selinux/include/flask.h                  |    1 +
 security/selinux/include/objsec.h                 |   11 -
 security/selinux/nlmsgtab.c                       |    3 +
 security/selinux/selinuxfs.c                      |   13 +-
 security/selinux/xfrm.c                           |    6 +-
 security/smack/smack_access.c                     |    4 +-
 security/smack/smack_lsm.c                        |  173 ++-
 security/smack/smackfs.c                          |    6 +-
 303 files changed, 21049 insertions(+), 3726 deletions(-)
 create mode 100644 Documentation/credentials.txt
 create mode 100644 Documentation/filesystems/caching/backend-api.txt
 create mode 100644 Documentation/filesystems/caching/cachefiles.txt
 create mode 100644 Documentation/filesystems/caching/fscache.txt
 create mode 100644 Documentation/filesystems/caching/netfs-api.txt
 create mode 100644 Documentation/filesystems/caching/object.txt
 create mode 100644 Documentation/filesystems/caching/operations.txt
 create mode 100644 Documentation/slow-work.txt
 create mode 100644 fs/cachefiles/Kconfig
 create mode 100644 fs/cachefiles/Makefile
 create mode 100644 fs/cachefiles/cf-bind.c
 create mode 100644 fs/cachefiles/cf-daemon.c
 create mode 100644 fs/cachefiles/cf-interface.c
 create mode 100644 fs/cachefiles/cf-internal.h
 create mode 100644 fs/cachefiles/cf-key.c
 create mode 100644 fs/cachefiles/cf-main.c
 create mode 100644 fs/cachefiles/cf-namei.c
 create mode 100644 fs/cachefiles/cf-proc.c
 create mode 100644 fs/cachefiles/cf-rdwr.c
 create mode 100644 fs/cachefiles/cf-security.c
 create mode 100644 fs/cachefiles/cf-xattr.c
 create mode 100644 fs/fscache/Kconfig
 create mode 100644 fs/fscache/Makefile
 create mode 100644 fs/fscache/fsc-cache.c
 create mode 100644 fs/fscache/fsc-cookie.c
 create mode 100644 fs/fscache/fsc-fsdef.c
 create mode 100644 fs/fscache/fsc-histogram.c
 create mode 100644 fs/fscache/fsc-internal.h
 create mode 100644 fs/fscache/fsc-main.c
 create mode 100644 fs/fscache/fsc-netfs.c
 create mode 100644 fs/fscache/fsc-object.c
 create mode 100644 fs/fscache/fsc-operation.c
 create mode 100644 fs/fscache/fsc-page.c
 create mode 100644 fs/fscache/fsc-proc.c
 create mode 100644 fs/fscache/fsc-stats.c
 create mode 100644 fs/nfs/fscache-index.c
 create mode 100644 fs/nfs/fscache.c
 create mode 100644 fs/nfs/fscache.h
 create mode 100644 include/keys/keyring-type.h
 create mode 100644 include/linux/fscache-cache.h
 create mode 100644 include/linux/fscache.h
 delete mode 100644 include/linux/key-ui.h
 create mode 100644 include/linux/slow-work.h
 create mode 100644 kernel/cred-internals.h
 create mode 100644 kernel/cred.c
 create mode 100644 kernel/slow-work.c
 create mode 100644 lib/is_single_threaded.c
