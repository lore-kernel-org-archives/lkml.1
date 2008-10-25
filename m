Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbYJYNur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbYJYNur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 09:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbYJYNuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 09:50:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36537 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbYJYNu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 09:50:27 -0400
Date: Sun, 26 Oct 2008 00:50:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: left over things in linux-next after 2.6.28-c1
Message-Id: <20081026005009.50dbbb33.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__26_Oct_2008_00_50_09_+1100_On/lOXeeKuNBxBvQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__26_Oct_2008_00_50_09_+1100_On/lOXeeKuNBxBvQ
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

The following is an approximate list of commits left in linux-next
relative to 2.6.28-rc1.  Some things here may have been included in
Linus' tree in a slightly different form.  The kvm tree is excluded from
this list because the bits of it submitted to Linus are often different
to what is in linux-next (my scipt says that it has ~1400 outstanding
commits).

The commit list for each tree is generated using this:

git rev-list --pretty=3D'format:%m%H' --no-merges --left-right --cherry-pic=
k \
	origin/master...$h | sed -n 's/^>//p'

(where $h is the branch for the tree)  If anyone has a better idea, then
please let me know as the above takes a long time on each tree.

driver-core.current

	Andi Kleen (1):
	      sysfs: Fix return values for sysdev_store_{ulong,int}

	Greg Kroah-Hartman (1):
	      Document kernel taint flags properly

	Qinghuang Feng (1):
	      driver core: drivers/base/sys.c: update comments

input-current

	Arjan Opmeer (1):
	      Input: psmouse - add support for Elantech touchpads

	Stefan Bader (1):
	      Input: i8042 - add Blue FB5601 to noloop exception table

cris

	Jesper Nilsson (1):
	      [CRISv32] Remove warning in io.h

m68k

	Geert Uytterhoeven (1):
	      m68k: Disable Amiga serial console support if modular

m68knommu

	Sebastian Siewior (1):
	      m68knommu: use one exist from execption

pxa

	Eric Miao (2):
	      [ARM] pxa: fix the corgi_ssp.c dependency issue in {corgi,spitz}_def=
config
	      [ARM] pxa: update {magician, eseries_pxa}_defconfig

s390

	Christian Borntraeger (2):
	      [S390] vmcp: remove BKL
	      [S390] pgtables: Fix race in enable_sie vs. page table ops

	Heiko Carstens (1):
	      [S390] Fix sysdev class file creation.

	Jan Glauber (2):
	      [S390] qdio: prevent double qdio shutdown in case of I/O errors
	      [S390] qdio: remove incorrect memset

x86

	Alexander van Heukelum (7):
	      i386, dumpstack: move crash_kexec before bust_spinlocks(0) in oops_e=
nd
	      x86, dumpstack: let signr=3D0 signal no do_exit
	      x86_64, dumpstack: move kexec_crash from __die to oops_end
	      x86, dumpstack: always call oops_exit from oops_end
	      i386, dumpstack: use x86_64's method to account die_nest_count
	      i386, dumpstack: use oops_begin/oops_end in die_nmi
	      i386, dumpstack: unify die()

	Sitsofe Wheeler (1):
	      x86: change OPTIMIZE_INLINING help to say enabling makes smaller ker=
nels

usb

	Denis Joseph Barrow (2):
	      HSO: fix hso_serial_close refcounting
	      HSO: put linefeeds on printk's in hso.c

	Greg Kroah-Hartman (2):
	      USB: remove warn() macro from usb.h
	      USB: remove info() macro from usb.h

tip-core

	Andrew Morton (1):
	      lock debug: sit tight when we are already in a panic

	Arjan van de Ven (2):
	      debug: add notifier chain debugging
	      debug: add notifier chain debugging, v2

	Heiko Carstens (1):
	      percpu: zero based percpu build error on s390

	Hiroshi Shimamoto (1):
	      uaccess: fix parameters inversion for __copy_from_user_inatomic()

	Ingo Molnar (3):
	      softlockup: increase hung tasks check from 2 minutes to 8 minutes
	      x86: some lock annotations for user copy paths, v3
	      Revert "lockdep: fix compilation when CONFIG_TRACE_IRQFLAGS_SUPPORT =
is not set"

	Mike Travis (2):
	      x86: extend percpu ops to 64 bit
	      Zero based percpu: infrastructure to rebase the per cpu area to zero

	Nick Piggin (3):
	      x86: some lock annotations for user copy paths
	      x86: some lock annotations for user copy paths, v2
	      sched: improve preempt debugging

	Peter Zijlstra (9):
	      lockstat: documentation update
	      lockdep: add might_lock() / might_lock_read()
	      lockstat: fixup signed division
	      futex: rely on get_user_pages() for shared futexes
	      futex: reduce mmap_sem usage
	      futex: use fast_gup()
	      futex: cleanup fshared
	      futex: fixup get_futex_key() for private futexes
	      lockstat: contend with points

	Rui Sousa (2):
	      lockdep: fix compilation when CONFIG_TRACE_IRQFLAGS_SUPPORT is not s=
et
	      lockdep, UML: fix compilation when CONFIG_TRACE_IRQFLAGS_SUPPORT is =
not set

cpus4096

	Ingo Molnar (1):
	      x86: add MAXSMP

	Mike Travis (3):
	      smp: reduce stack requirements for smp_call_function_mask
	      x86: reduce stack requirements for send_call_func_ipi
	      x86: restore 4096 limit for NR_CPUS

ftrace

	Lai Jiangshan (3):
	      markers: simplify marker_set_format()
	      markers: remove exported symbol marker_probe_cb_noarg()
	      markers: let marker_table be close to its comments

	Rakib Mullick (1):
	      ftrace: fix section mismatch warning.

	Steven Rostedt (6):
	      ftrace: do not enclose logic in WARN_ON
	      ftrace: release functions from hash
	      ftrace: fix depends
	      ftrace: rename FTRACE to FUNCTION_TRACER
	      ftrace: rename the ftrace tracer to function
	      ftrace: stack tracer only record when on stack

safe-poison-pointers

	Avi Kivity (1):
	      core, x86: make LIST_POISON less deadly

	Ingo Molnar (2):
	      x86: change LIST_POISON to 0xdead000000000000
	      poison-pointers: clean up, add comments

stackprotector

	Arjan van de Ven (5):
	      x86: setup stack canary for the idle threads
	      x86: add CONFIG_CC_STACKPROTECTOR self-test
	      stackprotector: turn not having the right gcc into a #warning
	      stackprotector: better self-test
	      x86: simplify stackprotector self-check

	Daniel Walker (1):
	      panic.c: fix whitespace additions

	Eric Sandeen (1):
	      stackprotector: use canary at end of stack to indicate overruns at o=
ops time

	Ingo Molnar (12):
	      x86: stackprotector & PARAVIRT fix
	      x86: fix stackprotector canary updates during context switches
	      x86: fix canary of the boot CPU's idle task
	      panic: print more informative messages on stackprotect failure
	      panic: print out stacktrace if DEBUG_BUGVERBOSE
	      x86: if stackprotector is enabled, thn use stack-protector-all by de=
fault
	      stackprotector: include files
	      stackprotector: add boot_init_stack_canary()
	      x86: fix the stackprotector canary of the boot CPU
	      x86: stackprotector: mix TSC to the boot canary
	      x86: unify stackprotector features
	      stackprotector: remove self-test

hid

	Jiri Kosina (1):
	      HID: non-input reports can also be numbered

jdelvare-hwmon

	Jean Delvare (4):
	      hwmon-vid: Add support for AMD family 10h CPUs
	      hwmon: (lm90) Fix handling of hysteresis value
	      hwmon: (lm90) Add support for the LM99 16 degree offset
	      hwmon: Don't overuse I2C_CLIENT_MODULE_PARM

	Mark van Doesburg (3):
	      hwmon: (f71882fg) Use sensor_device_attribute_2
	      hwmon: (f71882fg) Misc cleanups
	      hwmon: (f71882fg) Add PWM support

kernel-doc

	Randy Dunlap (3):
	      kernelh-kerndoc1
	      kerndoc-macro-find
	      doc-move-initrd-txt

xfs

	Alexey Dobriyan (1):
	      [XFS] remove xfs_log_ticket_zone on rmmod

	Barry Naujok (18):
	      [XFS] remove bhv_vname_t and xfs_rename code
	      [XFS] Split xfs_dir2_leafn_lookup_int into its two pieces of functio=
nality
	      [XFS] Cleanup xfs_attr a bit with xfs_name and remove cred
	      [XFS] Name operation vector for hash and compare
	      [XFS] Add op_flags field and helpers to xfs_da_args
	      dcache: Add case-insensitive support d_ci_add() routine
	      [XFS] Return case-insensitive match for dentry cache
	      [XFS] XFS: ASCII case-insensitive support
	      [XFS] kmem_free and kmem_realloc to use const void *
	      [XFS] Remove d_add call for an ENOENT lookup return code
	      [XFS] Zero uninitialised xfs_da_args structure in xfs_dir2.c
	      [XFS] Invalidate dentry in unlink/rmdir if in case-insensitive mode
	      [XFS] Fix returning case-preserved name with CI node form directories
	      [XFS] Fix CI lookup in leaf-form directories
	      [XFS] Remove final remnants of dirv1 macros and other stuff
	      [XFS] Sync up kernel and user-space headers
	      [XFS] Check agf_btreeblks is valid when reading in the AGF
	      [XFS] Show buffer address with debug hexdump on corruption

	Christoph Hellwig (117):
	      [XFS] cleanup xfs_vn_mknod
	      [XFS] vnode cleanup in xfs_fs_subr.c
	      [XFS] kill xfs_get_dir_entry
	      [XFS] kill xfs_rwlock/xfs_rwunlock
	      [XFS] don't encode parent in nfs filehandles unless nessecary
	      [XFS] cleanup vnode use in dmapi calls
	      [XFS] cleanup vnode use in xfs_create/mknod/mkdir
	      [XFS] cleanup vnode use in xfs_link
	      [XFS] cleanup vnode use in xfs_symlink and xfs_rename
	      [XFS] cleanup vnode use in xfs_lookup
	      [XFS] cleanup vnode use in xfs_lrw.c
	      [XFS] cleanup vnode use in xfs_iops.c
	      [XFS] cleanup vnode use in xfs_bmap.c
	      [XFS] Remove superflous xfs_readsb call in xfs_mountfs.
	      [XFS] cleanup root inode handling in xfs_fs_fill_super
	      [XFS] split xfs_ioc_xattr
	      [XFS] remove most calls to VN_RELE
	      [XFS] Don't validate symlink target component length
	      [XFS] allow enabling CONFIG_XFS_DEBUG
	      [XFS] remove sendfile leftovers
	      [XFS] remove dmapi cruft in xfs_file.c
	      [XFS] Remove VN_IS* macros and related cruft.
	      [XFS] kill xfs_getattr
	      [XFS] kill di_mode checks after xfs_iget
	      [XFS] xfs_rename: pass resblks to xfs_dir_removename
	      [XFS] simplify xfs_lookup
	      [XFS] shrink mrlock_t
	      [XFS] remove manual lookup from xfs_rename and simplify locking
	      [XFS] kill usesless IHOLD calls in xfs_rename
	      [XFS] kill parent =3D=3D child checks in xfs_remove and xfs_rmdir
	      [XFS] kill usesless IHOLD calls in xfs_remove and xfs_rmdir
	      [XFS] Add a new xfs_icsb_sync_counters_locked for the case where m_s=
b_lock
	      [XFS] split xfs_icsb_balance_counter
	      [XFS] kill XFS_ICSB_SB_LOCKED
	      [XFS] Kill attr_capable checks as already done in xattr_permission.
	      [XFS] Fix memory corruption with small buffer reads
	      [XFS] kill xfs_uuid_unmount
	      [XFS] merge xfs_mntupdate into xfs_fs_remount
	      [XFS] kill xfs_igrow_start and xfs_igrow_finish
	      [XFS] merge xfs_unmount into xfs_fs_put_super / xfs_fs_fill_super
	      [XFS] merge xfs_mount into xfs_fs_fill_super
	      [XFS] don't call xfs_freesb from xfs_mountfs failure case
	      [XFS] sort out opening and closing of the block devices
	      [XFS] add xfs_setup_devices helper
	      [XFS] allow xfs_args_allocate to fail
	      [XFS] kill xfs_mount_init
	      [XFS] kill calls to xfs_binval in the mount error path
	      [XFS] rename error2 goto label in xfs_fs_fill_super
	      [XFS] add missing call to xfs_filestream_unmount on xfs_mountfs fail=
ure
	      [XFS] Factor out code for whether inode has attributes or not.
	      [XFS] Switches xfs_vn_listxattr to set it's put_listent callback dir=
ectly
	      [XFS] Merge xfs_rmdir into xfs_remove
	      [XFS] Don't update i_size for directories and special files
	      [XFS] Check for invalid flags in xfs_attrlist_by_handle.
	      [XFS] attrmulti cleanup
	      [XFS] Don't update mtime on rename source
	      [XFS] streamline init/exit path
	      [XFS] fix mount option parsing in remount
	      [XFS] s/XFS_PURGE_INODE/IRELE/g s/VN_HOLD(XFS_ITOV())/IHOLD()/
	      [XFS] fix compilation without CONFIG_PROC_FS
	      [XFS] xfs_setattr currently doesn't just handle the attributes set t=
hrough
	      [XFS] Now that xfs_setattr is only used for attributes set from ->se=
tattr
	      [XFS] Remove vn_revalidate calls in xfs.
	      [XFS] don't leak m_fsname/m_rtname/m_logname
	      [XFS] Remove vn_from_inode()
	      [XFS] kill vn_to_inode
	      [XFS] remove spurious VN_HOLD/VN_RELE calls from xfs_acl.c
	      [XFS] remove remaining VN_HOLD calls
	      [XFS] implement IHOLD/IRELE directly
	      [XFS] kill INDUCE_IO_ERROR
	      [XFS] kill xfs_lock_dir_and_entry
	      [XFS] remove some easy bhv_vnode_t instances
	      [XFS] kill bhv_vnode_t
	      [XFS] sanitize xfs_initialize_vnode
	      [XFS] small cleanups in xfs_btree.c
	      [XFS] kill struct xfs_btree_hdr
	      [XFS] split up xfs_btree_init_cursor
	      [XFS] add generic btree types
	      [XFS] make btree root in inode support generic
	      [XFS] add a long pointers flag to xfs_btree_cur
	      [XFS] refactor xfs_btree_readahead
	      [XFS] refactor btree validation helpers
	      [XFS] make btree tracing generic
	      [XFS] add get_maxrecs btree operation
	      [XFS] add helpers for addressing entities inside a btree block
	      [XFS] implement generic xfs_btree_increment
	      [XFS] implement generic xfs_btree_decrement
	      [XFS] implement generic xfs_btree_lookup
	      [XFS] implement generic xfs_btree_updkey
	      [XFS] implement generic xfs_btree_update
	      [XFS] implement generic xfs_btree_rshift
	      [XFS] implement generic xfs_btree_lshift
	      [XFS] implement generic xfs_btree_split
	      [XFS] implement semi-generic xfs_btree_new_root
	      [XFS] move xfs_bmbt_newroot to common code
	      [XFS] implement generic xfs_btree_insert/insrec
	      [XFS] move xfs_bmbt_killroot to common code
	      [XFS] implement generic xfs_btree_delete/delrec
	      [XFS] implement generic xfs_btree_get_rec
	      [XFS] kill xfs_bmbt_log_block and xfs_bmbt_log_recs
	      [XFS] add keys_inorder and recs_inorder btree methods
	      [XFS] mark various functions in xfs_btree.c static
	      [XFS] make btree tracing generic
	      [XFS] Cleanup maxrecs calculation.
	      [XFS] cleanup btree record / key / ptr addressing macros.
	      [XFS] fix barrier fail detection
	      [XFS] Always use struct xfs_btree_block instead of short / longform
	      [XFS] Move XFS_BMAP_SANITY_CHECK out of line.
	      [XFS] split out two helpers from xfs_syncsub
	      [XFS] fix instant oops with tracing enabled
	      [XFS] kill struct xfs_mount_args
	      [XFS] fix the noquota mount option
	      [XFS] fix biosize option
	      [XFS] Trivial xfs_remove comment fixup
	      [XFS] stop using xfs_itobp in xfs_bulkstat
	      [XFS] free partially initialized inodes using destroy_inode
	      Inode: export symbol destroy_inode

	David Chinner (111):
	      [XFS] Factor xfs_itobp() and xfs_inotobp().
	      [XFS] Don't block pdflush when writing back inodes
	      [XFS] Remove the xfs_icluster structure
	      [XFS] Use xfs_inode_clean() in more places
	      [XFS] Prevent AIL lock contention during transaction completion
	      [XFS] Use atomics for iclog reference counting
	      [XFS] 977545 977545 977545 977545 977545 977545 xfsaild causing too =
many
	      [XFS] Update c/mtime correctly on truncates
	      [XFS] Use atomic counters for ktrace buffer indexes
	      [XFS] Use power-of-2 sized buffers to reduce overhead
	      [XFS] Fix superblock features2 field alignment problem
	      [XFS] fix inode leak in xfs_iget_core()
	      [XFS] Account for inode cluster alignment in all allocations
	      [XFS] Ensure a btree insert returns a valid cursor.
	      [XFS] Per iclog callback chain lock
	      [XFS] Remove the xlog_ticket allocator
	      [XFS] Reorganise xlog_t for better cacheline isolation of contention
	      [XFS] Fix lock inversion in forced shutdown.
	      [XFS] xfs_quiesce_fs() never returns an error. Mark it void.
	      [XFS] Remove useless whitespace in function prototypes
	      [XFS] xfs_icsb_counter_disabled() never returns an error.
	      [XFS] Report errors from xfs_reserve_blocks().
	      [XFS] xfs_qm_reset_dqcounts() does not return errors.
	      [XFS] Propagate xfs_qm_dqflush_all() errors.
	      [XFS] Check for dquot flush errors
	      [XFS] Clean up quotamount error handling.
	      [XFS] Catch errors resetting quota flags.
	      [XFS] Catch errors when turning off quotas.
	      [XFS] Propagate quota file truncation errors.
	      [XFS] Catch errors from xfs_acl_setmode().
	      [XFS] Catch errors from xfs_acl_vremove().
	      [XFS] Propagate xfs_trans_reserve() errors.
	      [XFS] Propagate errors from xfs_trans_commit().
	      [XFS] Clean up xfs_alloc_search_busy() return values.
	      [XFS] Make xfs_alloc_compute_aligned() void.
	      [XFS] xfs_bmap_adjacent() never returns an error.
	      [XFS] Warn if errors come from block_truncate_page().
	      [XFS] Check for xfs_free_extent() failing.
	      [XFS] Catch errors returned from xfs_bmap_last_offset().
	      [XFS] Ensure errors from xfs_bdstrat() are correctly checked.
	      [XFS] Ensure xfs_bawrite() errors are checked.
	      [XFS] xfs_bdwrite() does not return errors.
	      [XFS] Catch unwritten extent conversion errors.
	      [XFS] xfs_iflush_fork() never returns an error.
	      [XFS] xaiki@sgi.com xfs_bulkstat_one_dinode() never returns an error.
	      [XFS] Catch errors from xfs_imap().
	      [XFS] Don't allow silent errors in xfs_inactive().
	      [XFS] Check for errors when changing buffer pointers.
	      [XFS] Sanitise xfs_log_force error checking.
	      [XFS] Catch log unmount failures.
	      [XFS] Update XFS Documentation for ikeep and ihashsize
	      [XFS] Don't error out on good I/Os.
	      [XFS] 980084 fix logic error in xfs_alloc_ag_vextent_near()
	      [XFS] Remove periodic logging of in-core superblock counters.
	      [XFS] Ensure the inode is joined in xfs_itruncate_finish
	      [XFS] Don't double count reserved block changes on UP.
	      [XFS] Fix check for block zero access in xfs_write_iomap_allocate()
	      [XFS] Don't initialise new inode generation numbers to zero
	      [XFS] Include linux/random.h in all builds, not just debug builds.
	      [XFS] Don't allow memory reclaim to wait on the filesystem in inode
	      [XFS] Fix fsync() b0rkage.
	      [XFS] Fix inode list allocation size in writeback.
	      [XFS] Update valid fields in xfs_mount_log_sb()
	      [XFS] Use the generic bitops rather than implementing them ourselves.
	      [XFS] In several places we directly convert from the XFS inode to the
	      [XFS] Avoid directly referencing the VFS inode V2
	      [XFS] Kill shouty XFS_ITOV() macro
	      [XFS] XFS: Kill xfs_vtoi()
	      [XFS] Use KM_NOFS for incore inode extent tree allocation V2
	      [XFS] Make use of the init-once slab optimisation.
	      [XFS] add new btree statistics
	      [XFS] move sync code to its own file
	      [XFS] move xfssyncd code to xfs_sync.c
	      [XFS] Remove xfs_iflush_all and clean up xfs_finish_reclaim_all()
	      [XFS] don't block in xfs_qm_dqflush() during async writeback.
	      [XFS] Use the inode tree for finding dirty inodes
	      [XFS] Traverse inode trees when releasing dquots
	      [XFS] remove the mount inode list
	      [XFS] Use struct inodes instead of vnodes to kill vn_grab
	      [XFS] use xfs_sync_inodes rather than xfs_syncsub
	      [XFS] kill xfs_syncsub
	      [XFS] xfssyncd: don't call xfs_sync
	      [XFS] make SYNC_ATTR no longer use xfs_sync
	      [XFS] make SYNC_DELWRI no longer use xfs_sync
	      [XFS] Kill SYNC_CLOSE
	      [XFS] Kill xfs_sync()
	      [XFS] Move remaining quiesce code.
	      [XFS] factor xfs_iget_core() into hit and miss cases
	      [XFS] Never call mark_inode_dirty_sync() directly
	      [XFS] Combine the XFS and Linux inodes
	      [XFS] Prevent use-after-free caused by synchronous inode reclaim
	      [XFS] move inode reclaim functions to xfs_sync.c
	      [XFS] rename inode reclaim functions
	      [XFS] mark inodes for reclaim via a tag in the inode radix tree
	      [XFS] use the inode radix tree for reclaiming inodes
	      [XFS] kill deleted inodes list
	      [XFS] Prevent looping in xfs_sync_inodes_ag
	      [XFS] Account for allocated blocks when expanding directories
	      [XFS] Allocate the struct xfs_ail
	      [XFS] Use a cursor for AIL traversal.
	      [XFS] move the AIl traversal over to a consistent interface
	      [XFS] Allow 64 bit machines to avoid the AIL lock during flushes
	      [XFS] Move the AIL lock into the struct xfs_ail
	      [XFS] Given the log a pointer to the AIL
	      [XFS] Add ail pointer into log items
	      [XFS] Finish removing the mount pointer from the AIL API
	      [XFS] XFS: Check for valid transaction headers in recovery
	      Inode: Allow external initialisers
	      Inode: Allow external list initialisation
	      [XFS] Can't lock inodes in radix tree preload region
	      [XFS] avoid all reclaimable inodes in xfs_sync_inodes_ag

	Denys Vlasenko (3):
	      [XFS] Remove unused arg from kmem_free()
	      [XFS] Remove unused Falgs parameter from xfs_qm_dqpurge()
	      [XFS] Remove unused wbc parameter from xfs_start_page_writeback()

	Donald Douwsma (3):
	      [XFS] Remove the xfs_refcache, it was only needed while we were still
	      [XFS] Remove unused HAVE_SPLICE macro.
	      [XFS] Fix broken HAVE_SPLICE removal commit.

	Eric Sandeen (11):
	      [XFS] remove shouting-indirection macros from xfs_sb.h
	      [XFS] The forward declarations for the xfs_ioctl() helpers and the
	      [XFS] Ensure "both" features2 slots are consistent
	      [XFS] Always use di_forkoff when checking for attr space.
	      [XFS] Remove CONFIG_XFS_SECURITY.
	      [XFS] fix non-smp xfs build
	      [XFS]
	      [XFS] Pack some shortform dir2 structures for the ARM old ABI
	      [XFS] Disable queue flag test in barrier check.
	      [XFS] convert xfs to use ERR_CAST
	      [XFS] remove shouting-indirection macros from xfs_trans.h

	Harvey Harrison (2):
	      [XFS] Replace __inline with inline
	      [XFS] replace remaining __FUNCTION__ occurrences

	Josef 'Jeff' Sipek (1):
	      [XFS] Replace custom AIL linked-list code with struct list_head

	Josef Sipek (1):
	      [XFS] Update XFS documentation for noikeep/ikeep.

	Lachlan McIlroy (30):
	      [XFS] make inode reclaim synchronise with xfs_iflush_done()
	      [XFS] Fix regression due to refcache removal
	      [XFS] Prevent xfs_bmap_check_leaf_extents() from referencing unmapped
	      [XFS] xfs_dm_rdwr() needs to pass a vfsmount to dentry_open()
	      [XFS]
	      [XFS] Use the generic xattr methods.
	      [XFS] make inode reclaim wait for log I/O to complete
	      [XFS] fix extent corruption in xfs_iext_irec_compact_full()
	      [XFS] Convert ASSERTs to XFS_WANT_CORRUPTED_GOTOs
	      [XFS] Always reset btree cursor after an insert
	      [XFS] Use the generic xattr methods.
	      Revert "[XFS]"
	      [XFS] use minleft when allocating in xfs_bmbt_split()
	      [XFS] Restore the lowspace extent allocator algorithm
	      [XFS] Allow xfs_bmbt_split() to fallback to the lowspace allocator
	      [XFS] Don't assert if trying to mount with blocksize > pagesize
	      [XFS] fix use after free with external logs or real-time devices
	      [XFS] Do not access buffers after dropping reference count
	      [XFS] remove INT_GET and friends
	      [XFS] Use the same btree_cur union member for alloc and inobt trees.
	      [XFS] Merge up to 2.6.26
	      [XFS] Use xfs_idestroy() to cleanup an inode.
	      [XFS] Fix use-after-free with log and quotas
	      [XFS] Unlock inode before calling xfs_idestroy()
	      [XFS] Fix extent list corruption in xfs_iext_irec_compact_full().
	      [XFS] Remove xfs_iext_irec_compact_full()
	      [XFS] Wait for all I/O on truncate to zero file size
	      [XFS] Make xfs_btree_check_ptr() debug-only code.
	      [XFS] Remove kmem_zone_t argument from xfs_inode_init_once()
	      [XFS] Fix build warning - xfs_fs_alloc_inode() needs a return statem=
ent

	Matthew Wilcox (1):
	      [XFS] Convert l_flushsema to a sv_t

	Michael Nishimoto (1):
	      [XFS] Ensure that 2 GiB xfs logs work properly.

	Niv Sardi (6):
	      [XFS] actually check error returned by xfs_flush_pages, clean up and
	      [XFS] kill t_sema member of struct xfs_trans
	      [XFS] Move attr log alloc size calculator to another function.
	      [XFS] Move xfs_attr_rolltrans to xfs_trans_roll
	      [XFS] remove mounpoint UUID code
	      [XFS] Revert remove mounpoint UUID code

	Peter Leckie (2):
	      [XFS] Clean up dquot pincount code.
	      [XFS] Fix build brakage from patch "Clean up dquot pincount code"

	Stephen Rothwell (1):
	      [XFS] Fix build failure after enabling CONFIG_XFS_DEBUG

	Tim Shimmin (5):
	      [XFS] xfs_bmap_compute_maxlevels should be based on di_forkoff inste=
ad of
	      [XFS] Fix up noattr2 so that it will properly update the versionnum =
and
	      [XFS] Fix up warning for xfs_vn_listxatt's call of list_one_attr() w=
ith
	      [XFS] Fix up problem when CONFIG_XFS_POSIX_ACL is not set and yet we=
 still
	      [XFS] A bug was found in xfs_bmap_add_extent_unwritten_real(). In a

ieee1394

	David Moore (1):
	      firewire: Include iso timestamp in headers when header_size > 4

	Jay Fenlason (2):
	      firewire: add a client_list_lock
	      firewire: Survive more than 256 bus resets

	Stefan Richter (2):
	      firewire: fw-sbp2: extend failure check after SCSI probe
	      firewire: convert client_list_lock to mutex

tests

	Ananth N Mavinakayanahalli (7):
	      Add tests/ directory
	      Move locking selftests to tests/
	      Move rcutorture to tests/
	      Move rtmutex tester to tests/
	      Move lkdtm to tests/
	      Move kprobes smoke tests to tests/
	      Move backtrace selftests to tests/

ocfs2

	Tao Ma (1):
	      ocfs2: return 0 in page_mkwrite to let VFS retry.

mtd

	Huang Weiyi (1):
	      [MTD] [NAND] OMAP2: remove duplicated #include

	Steve Glendinning (1):
	      [JFFS2] Fix build failure with !CONFIG_JFFS2_FS_WRITEBUFFER

crypto

	Evgeniy Polyakov (1):
	      crypto: hifn - Disable driver when physical size exceeds 32 bits

	Harvey Harrison (1):
	      crypto: camellia - use kernel-provided bitops, unaligned access

	Kim Phillips (2):
	      crypto: talitos - Pass correct interrupt status to error handler
	      crypto: talitos - Perform auth check in h/w if on sec 2.1 and above

	Lee Nipper (1):
	      crypto: talitos - Implement done interrupt mitigation

	Neil Horman (1):
	      crypto: testmgr - Trigger a panic when self test fails in FIPS mode

	Vishnu Suresh (1):
	      crypto: talitos - Preempt overflow interrupts off-by-one fix

vfs

	Al Viro (1):
	      switch quota_on-related stuff to kern_path()

	Christoph Hellwig (3):
	      dm: kill lookup_device wrapper
	      switch all filesystems over to d_obtain_alias
	      kill d_alloc_anon

v9fs

	Tom Tucker (4):
	      9p: rdma: Set trans prior to requesting async connection ops
	      9p: Make all client spin locks IRQ safe
	      9p: Remove unneeded free of fcall for Flush
	      p9: Fix leak of waitqueue in request allocation path

rr

	Johannes Berg (1):
	      remove CONFIG_KMOD

	Mark McLoughlin (3):
	      virtio_net: Recycle some more rx buffer pages
	      virtio_net: Improve the recv buffer allocation scheme
	      virtio_net: hook up the set-tso ethtool op

	Matias Zabaljauregui (1):
	      lguest: move the initial guest page table creation code to the host

	Mike Travis (1):
	      cpumask:cpumask_size

	Rusty Russell (35):
	      lguest:fix-efi
	      lguest:fix-irq-vectors
	      cpumask: add for_each_cpu_mask_and function
	      x86 smp: modify send_IPI_mask interface to accept cpumask_t pointers
	      sched: Reduce stack size requirements in kernel/sched.c
	      cpumask:centralize-common-maps
	      cpumask:remove-min
	      cpumask:add-struct-cpumask
	      cpumask:convert-few-difficult-cpumask_t-users
	      cpumask:cpus_copy
	      cpumask:cpumask_var_t
	      x86:enable-MAXSMP
	      cpumask:CONFIG_NR_CPUS-always
	      cpumask:always-have-nr_cpu_ids
	      cpumask:add-nr_cpumask_bits
	      cpumask:all-ops-compare-against-nr_cpu_ids
	      cpumask:fix-impossible-percpu-accesses
	      cpumask:use-nr_cpu_ids-in-all-ops
	      cpumask:cpumask_bits-everywhere
	      cpumask:cpumask_of
	      cpumask:for_each_cpu
	      cpumask:cpumask_first-cpumask_next
	      cpumask:deprecate-any_online_cpu
	      cpumask:cpumask_any_but
	      cpumask:deprecate-CPUMASK_ALLOC
	      cpumask:use-alloc_cpumask_var-in-sched
	      cpumask:to_cpumask
	      cpumask:cpumap-accessors
	      cpumask:CPU_BITS_ALL-and-CPU_BITS_NONE
	      cpumask:cpu_online_mask-et-al
	      cpumask:cpu_all_mask-and-cpu_none_mask
	      cpumask:cleanup-ifdefs
	      cpumask:check-all-ops-for-limits
	      cpumask:smp_call_function_many
	      misc:work_on_cpu

gfs2

	Steven Whitehouse (3):
	      GFS2: Support for FIEMAP ioctl
	      GFS2: Rationalise header files
	      GFS2: Fix up jdata writepage/delete_inode

semaphore-removal

	Matthew Wilcox (8):
	      Convert bluetooth's hci_core to mutexes
	      Convert s3c2443-ac97 from semaphore to mutex
	      9p: Convert from mutex to spinlock
	      Convert bonding driver from rw_semaphore to mutex
	      Add mutex includes to ps3_gelic drivers
	      Convert ppp_async from semaphore to a completion
	      Convert ibmphp from semaphores
	      Convert board-nokia770 from semaphore to spinlock

trivial

	Jesper Juhl (2):
	      Update Trivial tree details in Japanese translation of SubmittingPat=
ches.
	      Update Trivial tree details in Chinese translation of SubmittingPatc=
hes.

	Nick Andrew (1):
	      Tighten up the use of loose

	Uwe Kleine-K=C3=B6nig (2):
	      fix typo "thier" -> "their" in drivers/base/sys.c
	      Fix typo "kernal" -> "kernel" in fs/proc/nommu.c

block

	FUJITA Tomonori (1):
	      block: remove unused ll_new_mergeable()

	Jens Axboe (1):
	      cfq-iosched: remove limit of dispatch depth of max 4 times quantum

firmware

	Jaswinder Singh (9):
	      firmware: convert e100 driver to request_firmware()
	      firmware: convert acenic driver to request_firmware()
	      firmware: convert tg3 driver to request_firmware()
	      firmware: convert av7110 driver to request_firmware()
	      Remove fdump tool for av7110 firmware
	      qla1280: use request_firmware
	      advansys: use request_firmware
	      qlogicpti: use request_firmware
	      starfire: use request_firmware()

	Takashi Iwai (1):
	      ALSA: wavefront - Always use request_firmware()

pcmcia

	Alan Cox (3):
	      pcmcia: IRQ_TYPE_EXCLUSIVE is long obsoleted
	      pcmcia: Whine harder about use of EXCLUSIVE
	      fdomain_cs: Sort out modules with duplicate description

kgdb

	Sonic Zhang (1):
	      kgdb: Make mem access function weak in kgdb.c and kgdb.h

slab

	Cyrill Gorcunov (1):
	      SLUB: cleanup - define macros instead of hardcoded numbers

	Eduard - Gabriel Munteanu (9):
	      kmemtrace: Core implementation.
	      kmemtrace: Additional documentation.
	      kmemtrace: SLAB hooks.
	      kmemtrace: SLOB hooks.
	      SLUB: Replace __builtin_return_address(0) with _RET_IP_.
	      kmemtrace: SLUB hooks.
	      kmemtrace: Fix typos in documentation.
	      kmemtrace: Better alternative to "kmemtrace: fix printk format warni=
ngs".
	      kmemtrace: SLUB hooks for caller-tracking functions.

	Pekka Enberg (3):
	      kmemtrace: remove unnecessary casts
	      kmemtrace: allow kmemtrace to be enabled after boot
	      kmemtrace: remove config option for enabling tracing at boot

	Tom Zanussi (1):
	      relayfs: fix infinite loop with splice()

kmemcheck

	Ingo Molnar (2):
	      kmemcheck: export kmemcheck_mark_initialized
	      kmemcheck: build fix

	Pekka Enberg (5):
	      x86: __show_registers() and __show_regs() API unification
	      slab: move struct kmem_cache to headers
	      kmemcheck: add Vegard and Pekka to MAINTAINERS
	      x86: add hooks for kmemcheck on x86_64
	      slab: add hooks for kmemcheck

	Randy Dunlap (1):
	      kmemcheck: include module.h to prevent warnings

	Vegard Nossum (34):
	      x86: add save_stack_trace_bp() for tracing from a specific stack fra=
me
	      stacktrace: add forward-declaration struct task_struct
	      tasklets: new tasklet scheduling function
	      kmemcheck: add the kmemcheck core
	      x86: add hooks for kmemcheck
	      kmemcheck: add mm functions
	      slub: add hooks for kmemcheck
	      kmemcheck: enable in the x86 Kconfig
	      kmemcheck: fix sparse warnings
	      softirq: raise the right softirq
	      kmemcheck: use the proper comment style
	      kmemcheck: fix use of uninitialized spinlock
	      kmemcheck: constrain tracking to non-debugged caches
	      kmemcheck: mark SMP support BROKEN
	      kmemcheck: use capital Y/N in kconfig help-texts
	      kmemcheck: remove unnecessary tests in the slab allocator
	      kmemcheck: add DMA hooks
	      kmemcheck: work with sizes in terms of bytes instead of bits
	      kmemcheck: allow memory accesses that cross page boundaries
	      kmemcheck: add some more documentation
	      kmemcheck: add some comments
	      kmemcheck: save memory contents on use of uninitialized memory
	      kmemcheck: implement REP MOVS/STOS emulation
	      kmemcheck: hide/show pages in each iteration of a REP instruction
	      kmemcheck: rip out the optimized memset()
	      kmemcheck: rip out SMP code
	      kmemcheck: hide/show pages in each iteration of a REP instruction #2
	      kmemcheck: lazy checking for MOVS instructions
	      Revert "kmemcheck: use set_memory_4k() instead of disabling PSE"
	      x86: use REP MOVS instruction for memcpy if kmemcheck is enabled
	      kmemcheck: use set_memory_4k() on x86_64 only
	      kmemcheck: fix crash in PnP BIOS calls
	      kmemcheck: tag warning printks
	      kmemcheck: (finally) use 4k pages for identity mapping

hdlc

	Krzysztof Ha=C5=82asa (15):
	      WAN: split hd6457x.c into hd64570.c and hd64572.c
	      WAN: remove SCA II support from SCA drivers
	      WAN: remove SCA support from SCA-II drivers
	      WAN: convert HD64572-based drivers to NAPI.
	      WAN: TX-done handler now uses the ownership bit in HD64572 drivers.
	      WAN: HD64572 already handles TX underruns with DMAC.
	      WAN: rework HD64572 interrupts a bit.
	      WAN: Simplify HD64572 status handling.
	      WAN: don't print HD64572 driver versions anymore.
	      WAN: Simplify HD64572 drivers.
	      WAN: HD64572 drivers don't use next_desc() anymore.
	      WAN: Correct comments in hd6457[02].c
	      WAN: Simplify sca_init_port() in HD64572 driver.
	      WAN: new synchronous PPP implementation for generic HDLC.
	      WAN: syncppp.c is no longer used by any kernel code. Remove it.

	Wang Chen (2):
	      netdevice hdlc: Convert directly reference of netdev->priv to netdev=
->ml_priv
	      netdevice pc300: Convert directly reference of netdev->priv to netde=
v->ml_priv

voltage

	Mark Brown (1):
	      regulator: Build on non-ARM platforms

ttydev

	Alan Cox (17):
	      blackfin-kgdb
	      blackfin-sir-stopfix
	      blackfin-clean-early
	      blackfin-rxtx-lock
	      blackfin-clear-bi
	      pty-simplify-resize
	      n-tty-clean
	      pty-remove-pts-global
	      pty-per-mount-allocated
	      pty-per-mount-config
	      pty-option-parsing
	      pty-pts-multiple-instances
	      pty-mknod-ptmx
	      pty-get-init-pts-sb
	      pty-pts-enable-multiple
	      pty-multiple-doc
	      pty-devpts-tidy

	Joe Peterson (1):
	      n-tty-bkl-drop

	Lee Howard (2):
	      8250-oxsemi
	      8250-oxsemi-mainpine

creds

	David Howells (77):
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
	      CRED: Use RCU to access another task's creds and to release a task's=
 own creds
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
	      CRED: Differentiate objective and effective subjective credentials o=
n a task
	      CRED: Add a kernel_service object class to SELinux
	      CRED: Allow kernel services to override LSM settings for task actions

oprofile

	Robert Richter (2):
	      oprofile: whitespace fixes
	      oprofile: more whitespace fixes

watchdog

	Arjan van de Ven (1):
	      [WATCHDOG] pci: use pci_ioremap_bar() in drivers/watchdog

	Wim Van Sebroeck (2):
	      [WATCHDOG] ib700wdt - add timeout parameter
	      [WATCHDOG] Add SMSC SCH311x Watchdog Timer.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__26_Oct_2008_00_50_09_+1100_On/lOXeeKuNBxBvQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkDJBEACgkQjjKRsyhoI8zjsgCgjgC6nEBB7Qae4wpt5Li57dor
bmQAniY+nCeRuGS1SQYz+TrchS0ts4wS
=PoPT
-----END PGP SIGNATURE-----

--Signature=_Sun__26_Oct_2008_00_50_09_+1100_On/lOXeeKuNBxBvQ--
