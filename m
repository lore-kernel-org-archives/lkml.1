Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbXH1L5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbXH1L5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 07:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756886AbXH1L4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 07:56:50 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:8021 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbXH1L4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 07:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=nHDsONsiyx4hZSjIuaEKeqEivkrwk3YPN8azqPLPXCZYh8LvvGUMAzSM3jKpBjrZpkWlQ/RxRxbLtZMASk/1F+9qZChtlkp2wLgfO8YJV9aB8A8RNCV4qyMzj0WwppMFf0EFrASLbYqfWPb0K57RbSgtHAKb7g7MmkohAyTo3vo=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] debloat aic7xxx and aic79xx drivers by deinlining
Date: Tue, 28 Aug 2007 12:56:34 +0100
User-Agent: KMail/1.9.1
Cc: Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de
References: <200708252257.07241.vda.linux@googlemail.com> <200708261621.30563.vda.linux@googlemail.com> <20070827020310.GC4121@stusta.de>
In-Reply-To: <20070827020310.GC4121@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708281256.35162.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 August 2007 03:03, Adrian Bunk wrote:
> On Sun, Aug 26, 2007 at 04:21:30PM +0100, Denys Vlasenko wrote:
> > On Saturday 25 August 2007 22:57, Arjan van de Ven wrote:
> >...
> >
> > > Did you run the find static
> > > script or are you waiting for Adrian to do that ;-)
> >
> > $ find -name '*find*static*'
> > $
>
>   make namespacecheck

Thanks, nice tool.

aic7xxx is kind of not very nice in this regard.

See below what I get even on non-patched driver.

I am willing to clean it up, but I still would like
"debloating" patch to be accepted.

Otherwise I'm left in the dark whether _any_ patches
touching aic7xxx are ever looked at, or not.

Okay, the list:

Externally defined symbols with no external references

  drivers/scsi/aic7xxx/aic79xx_reg_print.o
    ahd_abrtbitptr_print
    ahd_abrtbyteptr_print
    ahd_accum_print
    ahd_accum_save_print
    ahd_ahd_pci_config_base_print
    ahd_allocfifo_scbptr_print
    ahd_allones_print
    ahd_allzeros_print
    ahd_annexcol_print
    ahd_annexdat_print
    ahd_arbctl_print
    ahd_arg_1_print
    ahd_arg_2_print
    ahd_attrptr_print
    ahd_brdctl_print
    ahd_brddat_print
    ahd_brkaddr0_print
    ahd_brkaddr1_print
    ahd_businitid_print
    ahd_bustargid_print
    ahd_ccscbacnt_print
    ahd_ccscbaddr_print
    ahd_ccscbadr_bk_print
    ahd_ccscbram_print
    ahd_ccsgaddr_print
    ahd_ccsgram_print
    ahd_cdblimit_print
    ahd_clrerr_print
    ahd_clrint_print
    ahd_clrlqiint0_print
    ahd_clrlqiint1_print
    ahd_clrlqoint0_print
    ahd_clrlqoint1_print
    ahd_clrseqintsrc_print
    ahd_clrseqintstat_print
    ahd_clrsint0_print
    ahd_clrsint1_print
    ahd_clrsint2_print
    ahd_clrsint3_print
    ahd_cmc_rambist_print
    ahd_cmcpcistat_print
    ahd_cmcrxmsg0_print
    ahd_cmcrxmsg1_print
    ahd_cmcrxmsg2_print
    ahd_cmcrxmsg3_print
    ahd_cmcseqbcnt_print
    ahd_cmcspltstat0_print
    ahd_cmcspltstat1_print
    ahd_cmdlenptr_print
    ahd_cmdptr_print
    ahd_cmdrsvd0_print
    ahd_cmds_pending_print
    ahd_cmdsize_table_print
    ahd_complete_dma_scb_head_print
    ahd_complete_dma_scb_tail_print
    ahd_complete_on_qfreeze_head_print
    ahd_complete_scb_dmainprog_head_print
    ahd_complete_scb_head_print
    ahd_crccontrol_print
    ahd_curaddr_print
    ahd_currscb_print
    ahd_data_count_odd_print
    ahd_datalenptr_print
    ahd_dchrxmsg0_print
    ahd_dchrxmsg1_print
    ahd_dchrxmsg2_print
    ahd_dchrxmsg3_print
    ahd_dchseqbcnt_print
    ahd_dchspltstat0_print
    ahd_dchspltstat1_print
    ahd_df0pcistat_print
    ahd_df1pcistat_print
    ahd_dfbcnt_print
    ahd_dfbkptr_print
    ahd_dfdat_print
    ahd_dfdbctl_print
    ahd_dff_thrsh_print
    ahd_dfftag_print
    ahd_dfptrs_print
    ahd_dfraddr_print
    ahd_dfscnt_print
    ahd_dfwaddr_print
    ahd_dgrpcrci_print
    ahd_dindex_print
    ahd_dindir_print
    ahd_dlcount_print
    ahd_dmaparams_print
    ahd_dscommand0_print
    ahd_dspackctl_print
    ahd_dspdatactl_print
    ahd_dspfltrctl_print
    ahd_dspreqctl_print
    ahd_dspselect_print
    ahd_error_print
    ahd_fairness_print
    ahd_flagptr_print
    ahd_flags_print
    ahd_flexadr_print
    ahd_flexcnt_print
    ahd_flexdata_print
    ahd_flexdmastat_print
    ahd_function1_print
    ahd_gsfifo_print
    ahd_haddr_print
    ahd_hcnt_print
    ahd_hcntrl_print
    ahd_hescb_qoff_print
    ahd_hnscb_qoff_print
    ahd_hodmaadr_print
    ahd_hodmacnt_print
    ahd_hodmaen_print
    ahd_idptr_print
    ahd_initiator_tag_print
    ahd_int_coalescing_cmdcount_print
    ahd_int_coalescing_maxcmds_print
    ahd_int_coalescing_mincmds_print
    ahd_int_coalescing_timer_print
    ahd_intvec1_addr_print
    ahd_intvec2_addr_print
    ahd_iopdnctl_print
    ahd_iownid_print
    ahd_kernel_tqinpos_print
    ahd_last_msg_print
    ahd_lastaddr_print
    ahd_lastscb_print
    ahd_local_hs_mailbox_print
    ahd_longjmp_addr_print
    ahd_lqctl0_print
    ahd_lqctl1_print
    ahd_lqctl2_print
    ahd_lqimode0_print
    ahd_lqimode1_print
    ahd_lqin_print
    ahd_lqistate_print
    ahd_lqomode0_print
    ahd_lqomode1_print
    ahd_lqoscsctl_print
    ahd_lqostate_print
    ahd_lqrsvd01_print
    ahd_lqrsvd16_print
    ahd_lqrsvd17_print
    ahd_lunlen_print
    ahd_lunptr_print
    ahd_maxcmd2rcv_print
    ahd_maxcmd_print
    ahd_maxcmdbytes_print
    ahd_maxcmdcnt_print
    ahd_mode_ptr_print
    ahd_msg_out_print
    ahd_msipcistat_print
    ahd_multargid_print
    ahd_negconopts_print
    ahd_negoaddr_print
    ahd_negoffset_print
    ahd_negperiod_print
    ahd_negppropts_print
    ahd_next_queued_scb_addr_print
    ahd_nextscb_print
    ahd_none_print
    ahd_nsenable_print
    ahd_optionmode_print
    ahd_os_space_cnt_print
    ahd_ost_print
    ahd_ovlyaddr_print
    ahd_ovlypcistat_print
    ahd_ovlyrxmsg0_print
    ahd_ovlyrxmsg1_print
    ahd_ovlyrxmsg2_print
    ahd_ovlyrxmsg3_print
    ahd_ovlyseqbcnt_print
    ahd_ovlyspltstat0_print
    ahd_ovlyspltstat1_print
    ahd_packcrci_print
    ahd_pcixctl_print
    ahd_pll400cnt0_print
    ahd_pll400ctl0_print
    ahd_pll400ctl1_print
    ahd_pll960cnt0_print
    ahd_pll960ctl0_print
    ahd_pll960ctl1_print
    ahd_plldelay_print
    ahd_prgmcnt_print
    ahd_qnextptr_print
    ahd_qoff_ctlsta_print
    ahd_qoutfifo_entry_valid_tag_print
    ahd_qoutfifo_next_addr_print
    ahd_rcvrbiascalc_print
    ahd_rcvrbiosctl_print
    ahd_reg0_print
    ahd_reg1_print
    ahd_reg_isr_print
    ahd_roenable_print
    ahd_romaddr_print
    ahd_romcntrl_print
    ahd_romdata_print
    ahd_saved_lun_print
    ahd_saved_scsiid_print
    ahd_sblkctl_print
    ahd_scb_base_print
    ahd_scb_busaddr_print
    ahd_scb_cdb_len_print
    ahd_scb_datacnt_print
    ahd_scb_dataptr_print
    ahd_scb_disconnected_lists_print
    ahd_scb_lun_print
    ahd_scb_next2_print
    ahd_scb_next_print
    ahd_scb_residual_datacnt_print
    ahd_scb_residual_sgptr_print
    ahd_scb_scsi_status_print
    ahd_scb_sense_busaddr_print
    ahd_scb_sgptr_print
    ahd_scb_spare_print
    ahd_scb_tag_print
    ahd_scb_target_data_dir_print
    ahd_scb_target_itag_print
    ahd_scb_target_phases_print
    ahd_scb_task_attribute_print
    ahd_scb_task_management_print
    ahd_scbautoptr_print
    ahd_scbcnt_print
    ahd_scbhaddr_print
    ahd_scbhcnt_print
    ahd_scbptr_print
    ahd_scsbist0_print
    ahd_scsbist1_print
    ahd_scschkn_print
    ahd_scsidat0_img_print
    ahd_scsidat_print
    ahd_scsiseq_template_print
    ahd_scsisigo_print
    ahd_scsitest_print
    ahd_sdscb_qoff_print
    ahd_seeadr_print
    ahd_seectl_print
    ahd_seedat_print
    ahd_seestat_print
    ahd_seqctl1_print
    ahd_seqintcode_print
    ahd_seqram_print
    ahd_sescb_qoff_print
    ahd_sfunct_print
    ahd_sg_cache_pre_print
    ahd_sghaddr_print
    ahd_sghcnt_print
    ahd_sgpcistat_print
    ahd_sgrxmsg0_print
    ahd_sgrxmsg1_print
    ahd_sgrxmsg2_print
    ahd_sgrxmsg3_print
    ahd_sgseqbcnt_print
    ahd_sgspltstat0_print
    ahd_sgspltstat1_print
    ahd_shaddr_print
    ahd_shared_data_addr_print
    ahd_shcnt_print
    ahd_shortthresh_print
    ahd_simode2_print
    ahd_simode3_print
    ahd_sindex_print
    ahd_sindir_print
    ahd_skewcalc_print
    ahd_slvspltoutadr0_print
    ahd_slvspltoutadr1_print
    ahd_slvspltoutadr2_print
    ahd_slvspltoutadr3_print
    ahd_slvspltoutattr0_print
    ahd_slvspltoutattr1_print
    ahd_slvspltoutattr2_print
    ahd_snscb_qoff_print
    ahd_sram_base_print
    ahd_stack_print
    ahd_statlenptr_print
    ahd_swtimer_print
    ahd_sxfrctl0_print
    ahd_sxfrctl1_print
    ahd_sxfrctl2_print
    ahd_tagptr_print
    ahd_targidin_print
    ahd_targpcistat_print
    ahd_townid_print
    ahd_tqinpos_print
    ahd_typeptr_print
    ahd_unfairness_print
    ahd_waiting_scb_tails_print
    ahd_waiting_tid_head_print
    ahd_waiting_tid_tail_print
    ahd_wrtbiascalc_print
    ahd_wrtbiasctl_print
    ahd_xsig_print
  drivers/scsi/aic7xxx/aic7xxx_core.o
    ahc_abort_scbs
    ahc_busy_tcl
    ahc_calc_residual
    ahc_chip_names
    ahc_clear_critical_section
    ahc_clear_intstat
    ahc_freeze_devq
    ahc_index_busy_tcl
    ahc_lookup_phase_entry
    ahc_print_scb
    ahc_restart
    ahc_run_untagged_queue
    ahc_run_untagged_queues
    ahc_shutdown
    ahc_unbusy_tcl
    ahc_validate_offset
    ahc_validate_width
  drivers/scsi/aic7xxx/aic7xxx_proc.o
    ahc_format_transinfo
  drivers/scsi/aic7xxx/aic7xxx_reg_print.o
    ahc_accum_print
    ahc_allones_print
    ahc_allzeros_print
    ahc_arg_1_print
    ahc_arg_2_print
    ahc_bctl_print
    ahc_brdctl_print
    ahc_busspd_print
    ahc_bustime_print
    ahc_busy_targets_print
    ahc_cchaddr_print
    ahc_cchcnt_print
    ahc_ccscbaddr_print
    ahc_ccscbcnt_print
    ahc_ccscbctl_print
    ahc_ccscbptr_print
    ahc_ccscbram_print
    ahc_ccsgaddr_print
    ahc_ccsgctl_print
    ahc_ccsgram_print
    ahc_clrint_print
    ahc_clrsint0_print
    ahc_clrsint1_print
    ahc_cmdsize_table_tail_print
    ahc_complete_scbh_print
    ahc_crccontrol1_print
    ahc_dfdat_print
    ahc_dff_thrsh_print
    ahc_dfraddr_print
    ahc_dfwaddr_print
    ahc_dindex_print
    ahc_dindir_print
    ahc_disc_dsb_print
    ahc_disconnected_scbh_print
    ahc_dmaparams_print
    ahc_dscommand0_print
    ahc_dscommand1_print
    ahc_dspcistatus_print
    ahc_flags_print
    ahc_free_scbh_print
    ahc_function1_print
    ahc_ha_274_biosctrl_print
    ahc_ha_274_biosglobal_print
    ahc_haddr_print
    ahc_hcnt_print
    ahc_hcntrl_print
    ahc_hnscb_qoff_print
    ahc_hostconf_print
    ahc_hs_mailbox_print
    ahc_hscb_addr_print
    ahc_intdef_print
    ahc_intstat_print
    ahc_kernel_qinpos_print
    ahc_kernel_tqinpos_print
    ahc_last_msg_print
    ahc_msg_out_print
    ahc_mwi_residual_print
    ahc_next_queued_scb_print
    ahc_none_print
    ahc_optionmode_print
    ahc_qincnt_print
    ahc_qinfifo_print
    ahc_qinpos_print
    ahc_qoff_ctlsta_print
    ahc_qoutcnt_print
    ahc_qoutfifo_print
    ahc_qoutpos_print
    ahc_saved_lun_print
    ahc_saved_scsiid_print
    ahc_scamctl_print
    ahc_scb_64_btt_print
    ahc_scb_64_spare_print
    ahc_scb_base_print
    ahc_scb_cdb_len_print
    ahc_scb_cdb_ptr_print
    ahc_scb_datacnt_print
    ahc_scb_dataptr_print
    ahc_scb_next_print
    ahc_scb_residual_sgptr_print
    ahc_scb_scsi_status_print
    ahc_scb_scsioffset_print
    ahc_scb_scsirate_print
    ahc_scb_sgptr_print
    ahc_scb_target_data_dir_print
    ahc_scb_target_itag_print
    ahc_scb_target_phases_print
    ahc_scbbaddr_print
    ahc_scbcnt_print
    ahc_scbptr_print
    ahc_scsibush_print
    ahc_scsiconf_print
    ahc_scsidath_print
    ahc_scsidatl_print
    ahc_scsiid_print
    ahc_scsiid_ultra2_print
    ahc_scsiseq_template_print
    ahc_scsisigo_print
    ahc_sdscb_qoff_print
    ahc_seectl_2840_print
    ahc_seectl_print
    ahc_selid_print
    ahc_seltimer_print
    ahc_seq_flags2_print
    ahc_seqaddr0_print
    ahc_seqaddr1_print
    ahc_seqram_print
    ahc_sfunct_print
    ahc_sg_cache_pre_print
    ahc_sg_cache_shadow_print
    ahc_shaddr_print
    ahc_shared_data_addr_print
    ahc_sindex_print
    ahc_sindir_print
    ahc_snscb_qoff_print
    ahc_spiocap_print
    ahc_sram_base_print
    ahc_stack_print
    ahc_status_2840_print
    ahc_stcnt_print
    ahc_sxfrctl1_print
    ahc_sxfrctl2_print
    ahc_targ_offset_print
    ahc_targcrccnt_print
    ahc_targid_print
    ahc_tqinpos_print
    ahc_ultra_enb_print
    ahc_waiting_scbh_print
  drivers/scsi/aic94xx/aic94xx_dump.o
    asd_dump_ddb_0
    asd_dump_scb_list
    asd_dump_scb_sites
    asd_dump_target_ddb
  drivers/scsi/aic94xx/aic94xx_scb.o
    asd_build_initiate_link_adm_task
  drivers/scsi/aic94xx/aic94xx_seq.o
    asd_pause_cseq
    asd_pause_lseq
    asd_unpause_cseq
    asd_unpause_lseq
