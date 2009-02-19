Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbZBSEda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbZBSEda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 23:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZBSEdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 23:33:21 -0500
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:43954 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751585AbZBSEdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 23:33:20 -0500
X-YMail-OSG: hnd2a9EVM1n61BcYdTKYn4RAT1.3kSRN3K4Z4LzRFiL4300rfON15wWx2hekruTJcp4RywH3MUxSEvJN_sFK8FkjccEevbem.xkmsBe6iXor611D8A2iyDfpi_y712hUTqwztvZudOU0YJ.HWy667qJGXjCztaxQrUq.qwd6KYJR_zasM83nFK86sFpwVoXBJc186bcJ_31SDbZSw_3.mEM8XyNzuTFhTLnyMVBmVi7BAj282ZSIw6GumPksxWjQ9jRGF02YXSisQgZpO1f2iS7TXIA-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <499CE10A.8050906@schaufler-ca.com>
Date: Wed, 18 Feb 2009 20:33:14 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       Qinghuang Feng <qhfeng.kernel@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] smack: fix lots of kernel-doc notation
References: <20090218114233.2b5c662d.randy.dunlap@oracle.com>
In-Reply-To: <20090218114233.2b5c662d.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix/add kernel-doc notation and fix typos in security/smack/.
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>   

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

> cc: Casey Schaufler <casey@schaufler-ca.com>
> cc: James Morris <jmorris@namei.org>
> cc: Qinghuang Feng <qhfeng.kernel@gmail.com>
> ---
>  security/smack/smack_access.c |    4 +--
>  security/smack/smack_lsm.c    |   52 +++++++++++++++++++-----------------------
>  security/smack/smackfs.c      |   15 ++++++------
>  3 files changed, 34 insertions(+), 37 deletions(-)
>
> --- lnx2629-rc5-docsrc.orig/security/smack/smack_access.c
> +++ lnx2629-rc5-docsrc/security/smack/smack_access.c
> @@ -162,8 +162,8 @@ int smk_access(char *subject_label, char
>  
>  /**
>   * smk_curacc - determine if current has a specific access to an object
> - * @object_label: a pointer to the object's Smack label
> - * @request: the access requested, in "MAY" format
> + * @obj_label: a pointer to the object's Smack label
> + * @mode: the access requested, in "MAY" format
>   *
>   * This function checks the current subject label/object label pair
>   * in the access rule list and returns 0 if the access is permitted,
> --- lnx2629-rc5-docsrc.orig/security/smack/smackfs.c
> +++ lnx2629-rc5-docsrc/security/smack/smackfs.c
> @@ -245,7 +245,7 @@ out:
>  
>  /**
>   * smk_write_load - write() for /smack/load
> - * @filp: file pointer, not actually used
> + * @file: file pointer, not actually used
>   * @buf: where to get the data from
>   * @count: bytes sent
>   * @ppos: where to start - must be 0
> @@ -402,6 +402,7 @@ static void smk_cipso_doi(void)
>  
>  /**
>   * smk_unlbl_ambient - initialize the unlabeled domain
> + * @oldambient: previous domain string
>   */
>  static void smk_unlbl_ambient(char *oldambient)
>  {
> @@ -513,7 +514,7 @@ static int smk_open_cipso(struct inode *
>  
>  /**
>   * smk_write_cipso - write() for /smack/cipso
> - * @filp: file pointer, not actually used
> + * @file: file pointer, not actually used
>   * @buf: where to get the data from
>   * @count: bytes sent
>   * @ppos: where to start
> @@ -703,7 +704,7 @@ static int smk_open_netlbladdr(struct in
>  
>  /**
>   * smk_write_netlbladdr - write() for /smack/netlabel
> - * @filp: file pointer, not actually used
> + * @file: file pointer, not actually used
>   * @buf: where to get the data from
>   * @count: bytes sent
>   * @ppos: where to start
> @@ -850,7 +851,7 @@ static ssize_t smk_read_doi(struct file 
>  
>  /**
>   * smk_write_doi - write() for /smack/doi
> - * @filp: file pointer, not actually used
> + * @file: file pointer, not actually used
>   * @buf: where to get the data from
>   * @count: bytes sent
>   * @ppos: where to start
> @@ -915,7 +916,7 @@ static ssize_t smk_read_direct(struct fi
>  
>  /**
>   * smk_write_direct - write() for /smack/direct
> - * @filp: file pointer, not actually used
> + * @file: file pointer, not actually used
>   * @buf: where to get the data from
>   * @count: bytes sent
>   * @ppos: where to start
> @@ -990,7 +991,7 @@ static ssize_t smk_read_ambient(struct f
>  
>  /**
>   * smk_write_ambient - write() for /smack/ambient
> - * @filp: file pointer, not actually used
> + * @file: file pointer, not actually used
>   * @buf: where to get the data from
>   * @count: bytes sent
>   * @ppos: where to start
> @@ -1065,7 +1066,7 @@ static ssize_t smk_read_onlycap(struct f
>  
>  /**
>   * smk_write_onlycap - write() for /smack/onlycap
> - * @filp: file pointer, not actually used
> + * @file: file pointer, not actually used
>   * @buf: where to get the data from
>   * @count: bytes sent
>   * @ppos: where to start
> --- lnx2629-rc5-docsrc.orig/security/smack/smack_lsm.c
> +++ lnx2629-rc5-docsrc/security/smack/smack_lsm.c
> @@ -91,6 +91,7 @@ struct inode_smack *new_inode_smack(char
>  /**
>   * smack_ptrace_may_access - Smack approval on PTRACE_ATTACH
>   * @ctp: child task pointer
> + * @mode: ptrace attachment mode
>   *
>   * Returns 0 if access is OK, an error code otherwise
>   *
> @@ -203,9 +204,8 @@ static void smack_sb_free_security(struc
>  
>  /**
>   * smack_sb_copy_data - copy mount options data for processing
> - * @type: file system type
>   * @orig: where to start
> - * @smackopts
> + * @smackopts: mount options string
>   *
>   * Returns 0 on success or -ENOMEM on error.
>   *
> @@ -331,7 +331,7 @@ static int smack_sb_statfs(struct dentry
>  /**
>   * smack_sb_mount - Smack check for mounting
>   * @dev_name: unused
> - * @nd: mount point
> + * @path: mount point
>   * @type: unused
>   * @flags: unused
>   * @data: unused
> @@ -370,7 +370,7 @@ static int smack_sb_umount(struct vfsmou
>  
>  /**
>   * smack_inode_alloc_security - allocate an inode blob
> - * @inode - the inode in need of a blob
> + * @inode: the inode in need of a blob
>   *
>   * Returns 0 if it gets a blob, -ENOMEM otherwise
>   */
> @@ -384,7 +384,7 @@ static int smack_inode_alloc_security(st
>  
>  /**
>   * smack_inode_free_security - free an inode blob
> - * @inode - the inode with a blob
> + * @inode: the inode with a blob
>   *
>   * Clears the blob pointer in inode
>   */
> @@ -538,7 +538,6 @@ static int smack_inode_rename(struct ino
>   * smack_inode_permission - Smack version of permission()
>   * @inode: the inode in question
>   * @mask: the access requested
> - * @nd: unused
>   *
>   * This is the important Smack hook.
>   *
> @@ -701,8 +700,7 @@ static int smack_inode_removexattr(struc
>   * @inode: the object
>   * @name: attribute name
>   * @buffer: where to put the result
> - * @size: size of the buffer
> - * @err: unused
> + * @alloc: unused
>   *
>   * Returns the size of the attribute or an error code
>   */
> @@ -864,7 +862,7 @@ static int smack_file_ioctl(struct file 
>  /**
>   * smack_file_lock - Smack check on file locking
>   * @file: the object
> - * @cmd unused
> + * @cmd: unused
>   *
>   * Returns 0 if current has write access, error code otherwise
>   */
> @@ -1003,8 +1001,8 @@ static int smack_cred_prepare(struct cre
>  	return 0;
>  }
>  
> -/*
> - * commit new credentials
> +/**
> + * smack_cred_commit - commit new credentials
>   * @new: the new credentials
>   * @old: the original credentials
>   */
> @@ -1014,8 +1012,8 @@ static void smack_cred_commit(struct cre
>  
>  /**
>   * smack_kernel_act_as - Set the subjective context in a set of credentials
> - * @new points to the set of credentials to be modified.
> - * @secid specifies the security ID to be set
> + * @new: points to the set of credentials to be modified.
> + * @secid: specifies the security ID to be set
>   *
>   * Set the security data for a kernel service.
>   */
> @@ -1032,8 +1030,8 @@ static int smack_kernel_act_as(struct cr
>  
>  /**
>   * smack_kernel_create_files_as - Set the file creation label in a set of creds
> - * @new points to the set of credentials to be modified
> - * @inode points to the inode to use as a reference
> + * @new: points to the set of credentials to be modified
> + * @inode: points to the inode to use as a reference
>   *
>   * Set the file creation context in a set of credentials to the same
>   * as the objective context of the specified inode
> @@ -1242,7 +1240,7 @@ static int smack_task_wait(struct task_s
>  /**
>   * smack_task_to_inode - copy task smack into the inode blob
>   * @p: task to copy from
> - * inode: inode to copy to
> + * @inode: inode to copy to
>   *
>   * Sets the smack pointer in the inode security blob
>   */
> @@ -1260,7 +1258,7 @@ static void smack_task_to_inode(struct t
>   * smack_sk_alloc_security - Allocate a socket blob
>   * @sk: the socket
>   * @family: unused
> - * @priority: memory allocation priority
> + * @gfp_flags: memory allocation flags
>   *
>   * Assign Smack pointers to current
>   *
> @@ -2001,7 +1999,7 @@ static int smack_ipc_permission(struct k
>  
>  /**
>   * smack_ipc_getsecid - Extract smack security id
> - * @ipcp: the object permissions
> + * @ipp: the object permissions
>   * @secid: where result will be saved
>   */
>  static void smack_ipc_getsecid(struct kern_ipc_perm *ipp, u32 *secid)
> @@ -2278,7 +2276,7 @@ static int smack_unix_may_send(struct so
>  /**
>   * smack_socket_sendmsg - Smack check based on destination host
>   * @sock: the socket
> - * @msghdr: the message
> + * @msg: the message
>   * @size: the size of the message
>   *
>   * Return 0 if the current subject can write to the destination
> @@ -2319,8 +2317,7 @@ static int smack_socket_sendmsg(struct s
>  
>  
>  /**
> - * smack_from_secattr - Convert a netlabel attr.mls.lvl/attr.mls.cat
> - * 	pair to smack
> + * smack_from_secattr - Convert a netlabel attr.mls.lvl/attr.mls.cat pair to smack
>   * @sap: netlabel secattr
>   * @sip: where to put the result
>   *
> @@ -2441,7 +2438,7 @@ static int smack_socket_sock_rcv_skb(str
>   * @sock: the socket
>   * @optval: user's destination
>   * @optlen: size thereof
> - * @len: max thereoe
> + * @len: max thereof
>   *
>   * returns zero on success, an error code otherwise
>   */
> @@ -2776,7 +2773,7 @@ static void smack_audit_rule_free(void *
>  
>  #endif /* CONFIG_AUDIT */
>  
> -/*
> +/**
>   * smack_secid_to_secctx - return the smack label for a secid
>   * @secid: incoming integer
>   * @secdata: destination
> @@ -2793,7 +2790,7 @@ static int smack_secid_to_secctx(u32 sec
>  	return 0;
>  }
>  
> -/*
> +/**
>   * smack_secctx_to_secid - return the secid for a smack label
>   * @secdata: smack label
>   * @seclen: how long result is
> @@ -2807,11 +2804,10 @@ static int smack_secctx_to_secid(const c
>  	return 0;
>  }
>  
> -/*
> +/**
>   * smack_release_secctx - don't do anything.
> - * @key_ref: unused
> - * @context: unused
> - * @perm: unused
> + * @secdata: unused
> + * @seclen: unused
>   *
>   * Exists to make sure nothing gets done, and properly
>   */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   

