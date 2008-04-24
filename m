Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYDXByd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYDXByd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 21:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYDXByX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 21:54:23 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47749 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbYDXByT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 21:54:19 -0400
Date: Wed, 23 Apr 2008 20:54:16 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, serue@us.ibm.com
Subject: Re: [PATCH 1/4] capability: capability.h whitespace, syntax, and
	other cleanups
Message-ID: <20080424015416.GA13904@sergelap.austin.ibm.com>
References: <12089731541206-git-send-email-eparis@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12089731541206-git-send-email-eparis@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting eparis@redhat.com (eparis@redhat.com):
> From: Eric Paris <eparis@redhat.com>
> 
> This patch changes capability.h to fix whitespace and syntax issues.  Things that
> are fixed may include (does not not have to include)
> 
> whitespace at end of lines
> spaces followed by tabs
> spaces used instead of tabs
> spacing around parenthesis
> location of { around structs and else clauses
> location of * in pointer declarations
> removal of initialization of static data to keep it in the right section
> useless {} in if statemetns
> useless checking for NULL before kfree
> fixing of the indentation depth of switch statements
> no assignments in if statements
> include spaces around , in function calls
> and any number of other things I forgot to mention

Thanks.  Looks fine other than the inexplicable (afaics)
jumping of the capability #s by one tab for CAP_NET_ADMIN
and then again from CAP_IPC_OWNER on.

Hmm, well you also made some odd (inconsistent) tab+space choices at and
following cap_clear.

thanks,
-serge

> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---
>  include/linux/capability.h |  142 ++++++++++++++++++++++----------------------
>  1 files changed, 71 insertions(+), 71 deletions(-)
> 
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index 7d50ff6..63aeeea 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -28,14 +28,14 @@ struct task_struct;
>     library since the draft standard requires the use of malloc/free
>     etc.. */
> 
> -#define _LINUX_CAPABILITY_VERSION_1  0x19980330
> -#define _LINUX_CAPABILITY_U32S_1     1
> +#define _LINUX_CAPABILITY_VERSION_1	0x19980330
> +#define _LINUX_CAPABILITY_U32S_1	1
> 
> -#define _LINUX_CAPABILITY_VERSION_2  0x20071026
> -#define _LINUX_CAPABILITY_U32S_2     2
> +#define _LINUX_CAPABILITY_VERSION_2	0x20071026
> +#define _LINUX_CAPABILITY_U32S_2	2
> 
> -#define _LINUX_CAPABILITY_VERSION    _LINUX_CAPABILITY_VERSION_2
> -#define _LINUX_CAPABILITY_U32S       _LINUX_CAPABILITY_U32S_2
> +#define _LINUX_CAPABILITY_VERSION	_LINUX_CAPABILITY_VERSION_2
> +#define _LINUX_CAPABILITY_U32S		_LINUX_CAPABILITY_U32S_2
> 
>  typedef struct __user_cap_header_struct {
>  	__u32 version;
> @@ -43,9 +43,9 @@ typedef struct __user_cap_header_struct {
>  } __user *cap_user_header_t;
> 
>  typedef struct __user_cap_data_struct {
> -        __u32 effective;
> -        __u32 permitted;
> -        __u32 inheritable;
> +	__u32 effective;
> +	__u32 permitted;
> +	__u32 inheritable;
>  } __user *cap_user_data_t;
> 
> 
> @@ -57,23 +57,23 @@ typedef struct __user_cap_data_struct {
>  #define VFS_CAP_FLAGS_EFFECTIVE	0x000001
> 
>  #define VFS_CAP_REVISION_1	0x01000000
> -#define VFS_CAP_U32_1           1
> -#define XATTR_CAPS_SZ_1         (sizeof(__le32)*(1 + 2*VFS_CAP_U32_1))
> +#define VFS_CAP_U32_1		1
> +#define XATTR_CAPS_SZ_1		(sizeof(__le32)*(1 + 2*VFS_CAP_U32_1))
> 
>  #define VFS_CAP_REVISION_2	0x02000000
> -#define VFS_CAP_U32_2           2
> -#define XATTR_CAPS_SZ_2         (sizeof(__le32)*(1 + 2*VFS_CAP_U32_2))
> +#define VFS_CAP_U32_2		2
> +#define XATTR_CAPS_SZ_2		(sizeof(__le32)*(1 + 2*VFS_CAP_U32_2))
> 
> -#define XATTR_CAPS_SZ           XATTR_CAPS_SZ_2
> -#define VFS_CAP_U32             VFS_CAP_U32_2
> +#define XATTR_CAPS_SZ		XATTR_CAPS_SZ_2
> +#define VFS_CAP_U32		VFS_CAP_U32_2
>  #define VFS_CAP_REVISION	VFS_CAP_REVISION_2
> 
> 
>  struct vfs_cap_data {
> -	__le32 magic_etc;            /* Little endian */
> +	__le32 magic_etc;		/* Little endian */
>  	struct {
> -		__le32 permitted;    /* Little endian */
> -		__le32 inheritable;  /* Little endian */
> +		__le32 permitted;	/* Little endian */
> +		__le32 inheritable;	/* Little endian */
>  	} data[VFS_CAP_U32];
>  };
> 
> @@ -83,8 +83,8 @@ typedef struct kernel_cap_struct {
>  	__u32 cap[_LINUX_CAPABILITY_U32S];
>  } kernel_cap_t;
> 
> -#define _USER_CAP_HEADER_SIZE  (sizeof(struct __user_cap_header_struct))
> -#define _KERNEL_CAP_T_SIZE     (sizeof(kernel_cap_t))
> +#define _USER_CAP_HEADER_SIZE	(sizeof(struct __user_cap_header_struct))
> +#define _KERNEL_CAP_T_SIZE	(sizeof(kernel_cap_t))
> 
>  #endif
> 
> @@ -97,25 +97,25 @@ typedef struct kernel_cap_struct {
>     overrides the restriction of changing file ownership and group
>     ownership. */
> 
> -#define CAP_CHOWN            0
> +#define CAP_CHOWN		0
> 
>  /* Override all DAC access, including ACL execute access if
>     [_POSIX_ACL] is defined. Excluding DAC access covered by
>     CAP_LINUX_IMMUTABLE. */
> 
> -#define CAP_DAC_OVERRIDE     1
> +#define CAP_DAC_OVERRIDE	1
> 
>  /* Overrides all DAC restrictions regarding read and search on files
>     and directories, including ACL restrictions if [_POSIX_ACL] is
>     defined. Excluding DAC access covered by CAP_LINUX_IMMUTABLE. */
> 
> -#define CAP_DAC_READ_SEARCH  2
> +#define CAP_DAC_READ_SEARCH	2
> 
>  /* Overrides all restrictions about allowed operations on files, where
>     file owner ID must be equal to the user ID, except where CAP_FSETID
>     is applicable. It doesn't override MAC and DAC restrictions. */
> 
> -#define CAP_FOWNER           3
> +#define CAP_FOWNER		3
> 
>  /* Overrides the following restrictions that the effective user ID
>     shall match the file owner ID when setting the S_ISUID and S_ISGID
> @@ -124,24 +124,24 @@ typedef struct kernel_cap_struct {
>     the S_ISGID bit on that file; that the S_ISUID and S_ISGID bits are
>     cleared on successful return from chown(2) (not implemented). */
> 
> -#define CAP_FSETID           4
> +#define CAP_FSETID		4
> 
>  /* Overrides the restriction that the real or effective user ID of a
>     process sending a signal must match the real or effective user ID
>     of the process receiving the signal. */
> 
> -#define CAP_KILL             5
> +#define CAP_KILL		5
> 
>  /* Allows setgid(2) manipulation */
>  /* Allows setgroups(2) */
>  /* Allows forged gids on socket credentials passing. */
> 
> -#define CAP_SETGID           6
> +#define CAP_SETGID		6
> 
>  /* Allows set*uid(2) manipulation (including fsuid). */
>  /* Allows forged pids on socket credentials passing. */
> 
> -#define CAP_SETUID           7
> +#define CAP_SETUID		7
> 
> 
>  /**
> @@ -153,24 +153,24 @@ typedef struct kernel_cap_struct {
>   *   remove any capability in your permitted set from any pid
>   * With VFS support for capabilities (neither of above, but)
>   *   Add any capability from current's capability bounding set
> - *       to the current process' inheritable set
> + *	to the current process' inheritable set
>   *   Allow taking bits out of capability bounding set
>   */
> 
> -#define CAP_SETPCAP          8
> +#define CAP_SETPCAP		8
> 
>  /* Allow modification of S_IMMUTABLE and S_APPEND file attributes */
> 
> -#define CAP_LINUX_IMMUTABLE  9
> +#define CAP_LINUX_IMMUTABLE	9
> 
>  /* Allows binding to TCP/UDP sockets below 1024 */
>  /* Allows binding to ATM VCIs below 32 */
> 
> -#define CAP_NET_BIND_SERVICE 10
> +#define CAP_NET_BIND_SERVICE	10
> 
>  /* Allow broadcasting, listen to multicast */
> 
> -#define CAP_NET_BROADCAST    11
> +#define CAP_NET_BROADCAST	11
> 
>  /* Allow interface configuration */
>  /* Allow administration of IP firewall, masquerading and accounting */
> @@ -186,42 +186,42 @@ typedef struct kernel_cap_struct {
>  /* Allow read/write of device-specific registers */
>  /* Allow activation of ATM control sockets */
> 
> -#define CAP_NET_ADMIN        12
> +#define CAP_NET_ADMIN		12
> 
>  /* Allow use of RAW sockets */
>  /* Allow use of PACKET sockets */
> 
> -#define CAP_NET_RAW          13
> +#define CAP_NET_RAW		13
> 
>  /* Allow locking of shared memory segments */
>  /* Allow mlock and mlockall (which doesn't really have anything to do
>     with IPC) */
> 
> -#define CAP_IPC_LOCK         14
> +#define CAP_IPC_LOCK		14
> 
>  /* Override IPC ownership checks */
> 
> -#define CAP_IPC_OWNER        15
> +#define CAP_IPC_OWNER		15
> 
>  /* Insert and remove kernel modules - modify kernel without limit */
> -#define CAP_SYS_MODULE       16
> +#define CAP_SYS_MODULE		16
> 
>  /* Allow ioperm/iopl access */
>  /* Allow sending USB messages to any device via /proc/bus/usb */
> 
> -#define CAP_SYS_RAWIO        17
> +#define CAP_SYS_RAWIO		17
> 
>  /* Allow use of chroot() */
> 
> -#define CAP_SYS_CHROOT       18
> +#define CAP_SYS_CHROOT		18
> 
>  /* Allow ptrace() of any process */
> 
> -#define CAP_SYS_PTRACE       19
> +#define CAP_SYS_PTRACE		19
> 
>  /* Allow configuration of process accounting */
> 
> -#define CAP_SYS_PACCT        20
> +#define CAP_SYS_PACCT		20
> 
>  /* Allow configuration of the secure attention key */
>  /* Allow administration of the random device */
> @@ -261,11 +261,11 @@ typedef struct kernel_cap_struct {
>  /* Allow setting encryption key on loopback filesystem */
>  /* Allow setting zone reclaim policy */
> 
> -#define CAP_SYS_ADMIN        21
> +#define CAP_SYS_ADMIN		21
> 
>  /* Allow use of reboot() */
> 
> -#define CAP_SYS_BOOT         22
> +#define CAP_SYS_BOOT		22
> 
>  /* Allow raising priority and setting priority on other (different
>     UID) processes */
> @@ -274,7 +274,7 @@ typedef struct kernel_cap_struct {
>     process. */
>  /* Allow setting cpu affinity on other processes */
> 
> -#define CAP_SYS_NICE         23
> +#define CAP_SYS_NICE		23
> 
>  /* Override resource limits. Set resource limits. */
>  /* Override quota limits. */
> @@ -288,32 +288,32 @@ typedef struct kernel_cap_struct {
>  /* Override max number of consoles on console allocation */
>  /* Override max number of keymaps */
> 
> -#define CAP_SYS_RESOURCE     24
> +#define CAP_SYS_RESOURCE	24
> 
>  /* Allow manipulation of system clock */
>  /* Allow irix_stime on mips */
>  /* Allow setting the real-time clock */
> 
> -#define CAP_SYS_TIME         25
> +#define CAP_SYS_TIME		25
> 
>  /* Allow configuration of tty devices */
>  /* Allow vhangup() of tty */
> 
> -#define CAP_SYS_TTY_CONFIG   26
> +#define CAP_SYS_TTY_CONFIG	26
> 
>  /* Allow the privileged aspects of mknod() */
> 
> -#define CAP_MKNOD            27
> +#define CAP_MKNOD		27
> 
>  /* Allow taking of leases on files */
> 
> -#define CAP_LEASE            28
> +#define CAP_LEASE		28
> 
> -#define CAP_AUDIT_WRITE      29
> +#define CAP_AUDIT_WRITE		29
> 
> -#define CAP_AUDIT_CONTROL    30
> +#define CAP_AUDIT_CONTROL	30
> 
> -#define CAP_SETFCAP	     31
> +#define CAP_SETFCAP		31
> 
>  /* Override MAC access.
>     The base kernel enforces no MAC policy.
> @@ -321,7 +321,7 @@ typedef struct kernel_cap_struct {
>     to implement capability based overrides of that policy, this is
>     the capability it should use to do so. */
> 
> -#define CAP_MAC_OVERRIDE     32
> +#define CAP_MAC_OVERRIDE	32
> 
>  /* Allow MAC configuration or state changes.
>     The base kernel requires no MAC configuration.
> @@ -330,9 +330,9 @@ typedef struct kernel_cap_struct {
>     policy or the data required to maintain it, this is the
>     capability it should use to do so. */
> 
> -#define CAP_MAC_ADMIN        33
> +#define CAP_MAC_ADMIN		33
> 
> -#define CAP_LAST_CAP         CAP_MAC_ADMIN
> +#define CAP_LAST_CAP		CAP_MAC_ADMIN
> 
>  #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
> 
> @@ -340,8 +340,8 @@ typedef struct kernel_cap_struct {
>   * Bit location of each capability (used by user-space library and kernel)
>   */
> 
> -#define CAP_TO_INDEX(x)     ((x) >> 5)        /* 1 << 5 == bits in __u32 */
> -#define CAP_TO_MASK(x)      (1 << ((x) & 31)) /* mask for indexed __u32 */
> +#define CAP_TO_INDEX(x)     ((x) >> 5)		/* 1 << 5 == bits in __u32 */
> +#define CAP_TO_MASK(x)      (1 << ((x) & 31))	/* mask for indexed __u32 */
> 
>  #ifdef __KERNEL__
> 
> @@ -375,7 +375,7 @@ typedef struct kernel_cap_struct {
> 
>  #define CAP_INIT_INH_SET    CAP_EMPTY_SET
> 
> -# define cap_clear(c)         do { (c) = __cap_empty_set; } while (0)
> +# define cap_clear(c)	      do { (c) = __cap_empty_set; } while (0)
>  # define cap_set_full(c)      do { (c) = __cap_full_set; } while (0)
>  # define cap_set_init_eff(c)  do { (c) = __cap_init_eff_set; } while (0)
> 
> @@ -383,20 +383,20 @@ typedef struct kernel_cap_struct {
>  #define cap_lower(c, flag)  ((c).cap[CAP_TO_INDEX(flag)] &= ~CAP_TO_MASK(flag))
>  #define cap_raised(c, flag) ((c).cap[CAP_TO_INDEX(flag)] & CAP_TO_MASK(flag))
> 
> -#define CAP_BOP_ALL(c, a, b, OP)                                    \
> -do {                                                                \
> -	unsigned __capi;                                            \
> -	CAP_FOR_EACH_U32(__capi) {                                  \
> -		c.cap[__capi] = a.cap[__capi] OP b.cap[__capi];     \
> -	}                                                           \
> +#define CAP_BOP_ALL(c, a, b, OP)				\
> +do {								\
> +	unsigned __capi;					\
> +	CAP_FOR_EACH_U32(__capi) {				\
> +		c.cap[__capi] = a.cap[__capi] OP b.cap[__capi];	\
> +	}							\
>  } while (0)
> 
> -#define CAP_UOP_ALL(c, a, OP)                                       \
> -do {                                                                \
> -	unsigned __capi;                                            \
> -	CAP_FOR_EACH_U32(__capi) {                                  \
> -		c.cap[__capi] = OP a.cap[__capi];                   \
> -	}                                                           \
> +#define CAP_UOP_ALL(c, a, OP)					\
> +do {								\
> +	unsigned __capi;					\
> +	CAP_FOR_EACH_U32(__capi) {				\
> +		c.cap[__capi] = OP a.cap[__capi];		\
> +	}							\
>  } while (0)
> 
>  static inline kernel_cap_t cap_combine(const kernel_cap_t a,
> -- 
> 1.5.2.1
